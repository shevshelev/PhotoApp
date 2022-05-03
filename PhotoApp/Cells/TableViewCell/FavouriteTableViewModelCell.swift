//
//  FavouriteTableViewModelCell.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 03.05.2022.
//

import Foundation

protocol FavouriteTableViewModelCellProtocol {
    var reuseID: String { get }
    var aspectRatio: Double { get }
    var image: String { get }
    init(photo: Photo)
}
class FavouriteTableViewModelCell: FavouriteTableViewModelCellProtocol {
    var reuseID: String {
        "FavouriteCell"
    }
    
    var aspectRatio: Double {
        Double(photo.height) / Double(photo.width)
    }
    
    var image: String {
        photo.urls["regular"] ?? ""
    }
    
    private let photo: Photo
    
    required init(photo: Photo) {
        self.photo = photo
    }
    
    
}
