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
    func checkFavouriteStatus()
    init(photo: Photo, dataManager: DataManagerProtocol)
}

final class DetailViewModel: DetailViewModelProtocol {
    
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
    
    private let dataManager: DataManagerProtocol
    private let photo: Photo
    
    required init(photo: Photo, dataManager: DataManagerProtocol) {
        self.photo = photo
        self.dataManager = dataManager
        isFavourite = Box(dataManager.getFavouriteStatus(for: photo.id))
    }
    
    func checkFavouriteStatus() {
        isFavourite = Box(dataManager.getFavouriteStatus(for: photo.id))
    }
    
    @objc func setFavouriteStatus() {
        isFavourite.value.toggle()
        dataManager.setFavouriteStatus(for: photo.id, with: isFavourite.value)
        if isFavourite.value {
            dataManager.addToFavourites(photoId: photo.id)
        } else {
            dataManager.removeFromFavourites(photoId: photo.id)
        }
    }
    
    
}
