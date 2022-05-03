//
//  DetailViewModel.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 03.05.2022.
//

import Foundation

protocol DetailViewModelProtocol {
    var image: String { get }
    var description: String { get }
    var userName: String { get }
    var urls: [String: String] { get }
    var aspectRatio: Double { get }
    var isFavourite: Box<Bool> { get }
    func setFavouriteStatus()
    init(photo: Photo)
}

class DetailViewModel: DetailViewModelProtocol {
    var image: String {
        photo.urls["regular"] ?? ""
    }
    
    var description: String {
        (photo.photoDescription ?? "") + " " + (photo.altDescription ?? "")
    }
    var aspectRatio: Double {
        Double(photo.height) / Double(photo .width)
    }
    
    var userName: String {
        photo.user.userName
    }
    
    var urls: [String : String] {
        photo.urls
    }
    
    var isFavourite: Box<Bool>
    
    private let photo: Photo
    
    required init(photo: Photo) {
        self.photo = photo
        isFavourite = Box(DataManager.shared.getFavouriteStatus(for: photo.id))
    }
    
    @objc func setFavouriteStatus() {
        isFavourite.value.toggle()
        DataManager.shared.setFavouriteStatus(for: photo.id, with: isFavourite.value)
        if isFavourite.value {
            DataManager.shared.addToFavourites(photoId: photo.id)
        } else {
            DataManager.shared.removeFromFavourites(photoId: photo.id)
        }
    }
    
    
}
