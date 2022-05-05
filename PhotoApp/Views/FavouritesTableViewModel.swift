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
    func getPhoto(at indexPath: IndexPath) -> Photo
    func updatePhotos(completion: @escaping () -> Void)
}

final class FavouritesTableViewModel: FavouritesTableViewModelProtocol {
    
    private let dataManager: DataManagerProtocol
    private let networkManager: NetworkManagerProtocol
    
    private var favourites: [String] = []
    private var photos: [Photo] = []
    
    
    init(dataManager: DataManagerProtocol, networkManager: NetworkManagerProtocol) {
        self.dataManager = dataManager
        self.networkManager = networkManager
    }
    
    func fetchPhotos(completion: @escaping () -> Void) {
        favourites = dataManager.getFavourites()
        favourites.forEach {
            networkManager.fetchImages(type: .single(photoID: $0)) { [unowned self] photo in
                guard let photo = photo as? Photo else { return }
                self.photos.append(photo)
                completion()
            }
        }
    }
    
    func updatePhotos(completion: @escaping () -> Void) {
        let updatedFavourites = dataManager.getFavourites()
        let newFavorites = updatedFavourites.filter { !favourites.contains($0)}
        let removedFromFavorites = favourites.filter {
            !updatedFavourites.contains($0)
        }
        if !newFavorites.isEmpty {
            newFavorites.forEach {
                networkManager.fetchImages(type: .single(photoID: $0)) { [unowned self] photo in
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
    
    func getPhoto(at indexPath: IndexPath) -> Photo {
        photos[indexPath.row]
    }
    
    func deleteFormFavourites(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        dataManager.setFavouriteStatus(for: photo.id, with: false)
        dataManager.removeFromFavourites(photoId: photo.id)
    }
}
