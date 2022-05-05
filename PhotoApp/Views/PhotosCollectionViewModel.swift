//
//  PhotosCollectionViewModel.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 02.05.2022.
//

import Foundation

protocol PhotosCollectionViewModelProtocol {
    func fetchPhoto(type: ImageRequestType, completion: @escaping () -> Void)
    func numberOfItems() -> Int
    func photoCellViewModel(at indexPath: IndexPath) -> PhotoCollectionViewModelCellProtocol
    func getPhoto(at indexPath: IndexPath) -> Photo
}

final class PhotosCollectionViewModel: PhotosCollectionViewModelProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let dataManager: DataManagerProtocol
    
    init(networkManager: NetworkManagerProtocol, dataManager: DataManagerProtocol) {
        self.networkManager = networkManager
        self.dataManager = dataManager
    }
    
    private var photos: [Photo] = []
    
    func fetchPhoto(type: ImageRequestType, completion: @escaping () -> Void) {
        networkManager.fetchImages(type: type) { [unowned self] result in
            switch type {
            case .random:
                guard let result = result as? [Photo] else { return }
                self.photos = result
                completion()
            default:
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
        PhotoCollectionViewModelCell(photo: photos[indexPath.item], dataManager: dataManager)
    }
    
    func getPhoto(at indexPath: IndexPath) -> Photo {
        photos[indexPath.item]
    }
}
