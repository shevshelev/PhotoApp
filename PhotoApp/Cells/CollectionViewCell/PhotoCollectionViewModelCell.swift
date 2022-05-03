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
    init(photo: Photo)
}

class PhotoCollectionViewModelCell: PhotoCollectionViewModelCellProtocol {
    var isFavorite: Box<Bool>
    var reuseID: String {
        "PhotoCell"
    }
    var image: String {
        photo.urls["small"] ?? ""
    }
    private let photo: Photo
    
    required init(photo: Photo) {
        self.photo = photo
        isFavorite = Box(DataManager.shared.getFavouriteStatus(for: photo.id))
    }
}
