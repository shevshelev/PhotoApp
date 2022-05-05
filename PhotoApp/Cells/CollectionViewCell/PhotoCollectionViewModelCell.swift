//
//  PhotoCollectionViewModelCell.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 02.05.2022.
//

import Foundation

protocol PhotoCollectionViewModelCellProtocol {
    var reuseID: String { get }
    var image: String { get }
    var isFavorite: Box<Bool> { get }
    var aspectRatio: Double { get }
    init(photo: Photo, dataManager: DataManagerProtocol)
}

final class PhotoCollectionViewModelCell: PhotoCollectionViewModelCellProtocol {
    var isFavorite: Box<Bool>
    var reuseID: String {
        "PhotoCell"
    }
    var image: String {
        photo.urls["small"] ?? ""
    }
    var aspectRatio: Double {
        Double(photo.height) / Double(photo.width)
    }
    private let photo: Photo
    private let dataManager: DataManagerProtocol
    
    required init(photo: Photo, dataManager: DataManagerProtocol) {
        self.photo = photo
        self.dataManager = dataManager
        isFavorite = Box(dataManager.getFavouriteStatus(for: photo.id))
    }
}
