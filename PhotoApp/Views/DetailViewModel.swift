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
    init(photo: Photo)
}

class DetailViewModel: DetailViewModelProtocol {
    var image: String {
        photo.urls["regular"] ?? ""
    }
    
    var description: String {
        (photo.photoDescription ?? "") + " " + (photo.altDescription ?? "")
    }
    
    var userName: String {
        photo.user.userName ?? ""
    }
    
    var urls: [String : String] {
        photo.urls
    }
    
    private let photo: Photo
    
    required init(photo: Photo) {
        self.photo = photo
    }
    
    
}
