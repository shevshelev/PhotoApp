//
//  PhotosCollectionViewModel.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 02.05.2022.
//

import Foundation

protocol PhotosCollectionViewModelProtocol {
    func fetchPhoto(type: ImageRequestType, searchTerm: String?, completion: @escaping () -> Void)
    func numberOfItems() -> Int
    func photoCellViewModel(at indexPath: IndexPath) -> PhotoCollectionViewModelCellProtocol
    func detailsViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol
}

class PhotosCollectionViewModel: PhotosCollectionViewModelProtocol {
    
    private var photos: [Photo] = []
    
    func fetchPhoto(type: ImageRequestType, searchTerm: String?, completion: @escaping () -> Void) {
        NetworkManager.shared.fetchImages(type: type, with: searchTerm, or: nil) { [unowned self] result in
            if searchTerm == nil {
                guard let result = result as? [Photo] else { return }
                self.photos = result
                completion()
            } else {
                guard let result = result as? SearchResults else { return }
                self.photos = result.results
                completion()
            }
        }
    }
    
    func numberOfItems() -> Int {
        photos.count
    }
    
    func photoCellViewModel(at indexPath: IndexPath) -> PhotoCollectionViewModelCellProtocol {
        PhotoCollectionViewModelCell(photo: photos[indexPath.item])
    }
    
    func detailsViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol {
        DetailViewModel(photo: photos[indexPath.item])
    }
    
    
}
