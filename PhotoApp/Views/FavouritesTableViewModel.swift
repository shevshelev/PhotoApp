//
//  FavouritesTableViewModel.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 03.05.2022.
//

import Foundation

protocol FavouritesTableViewModelProtocol {
    func fetchPhotos(completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func deleteFormFavourites(at indexPath: IndexPath)
    func favouritesCellViewModel(at indexPath: IndexPath) -> FavouriteTableViewModelCell
    func detailsViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol
    func updatePhotos(completion: @escaping () -> Void)
}

class FavouritesTableViewModel: FavouritesTableViewModelProtocol {
    
    private var favourites = DataManager.shared.getFavourites()
    
    private var photos: [Photo] = []
    
    func fetchPhotos(completion: @escaping () -> Void) {
        favourites.forEach {
            NetworkManager.shared.fetchImages(type: .single, with: nil, or: $0) { [unowned self] photo in
                guard let photo = photo as? Photo else { return }
                self.photos.append(photo)
                completion()
            }
        }
    }
    
    func updatePhotos(completion: @escaping () -> Void) {
        let updatedFavourites = DataManager.shared.getFavourites()
        let newFaworites = updatedFavourites.filter { !favourites.contains($0)}
        let removedFromFavorites = favourites.filter {
            !updatedFavourites.contains($0)
        }
        if !newFaworites.isEmpty {
            newFaworites.forEach {
                NetworkManager.shared.fetchImages(type: .single, with: nil, or: $0) { [unowned self] photo in
                    guard let photo = photo as? Photo else { return }
                    self.photos.append(photo)
                    completion()
                }
            }
        } 
        if !removedFromFavorites.isEmpty {
            photos = photos.filter { !removedFromFavorites.contains($0.id)}
            completion()
        }
        favourites = updatedFavourites
    }
    
    func numberOfRows() -> Int {
        photos.count
    }
    
    func favouritesCellViewModel(at indexPath: IndexPath) -> FavouriteTableViewModelCell {
        FavouriteTableViewModelCell(photo: photos[indexPath.row])
    }
    
    func detailsViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol {
        DetailViewModel(photo: photos[indexPath.row])
    }
    
    func deleteFormFavourites(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        DataManager.shared.setFavouriteStatus(for: photo.id, with: false)
        DataManager.shared.removeFromFavourites(photoId: photo.id)
    }
}
