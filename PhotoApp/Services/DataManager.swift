//
//  DataManager.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 02.05.2022.
//

import Foundation

protocol DataManagerProtocol {
    func setFavouriteStatus(for photoId: String, with status: Bool)
    func getFavouriteStatus(for photoID: String) -> Bool
    func addToFavourites(photoId: String)
    func removeFromFavourites(photoId: String)
    func getFavourites() -> [String]
}

final class DataManager: DataManagerProtocol {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults()
    private let kFavourites = "Favourite"
    
    private init() {}
    
    func setFavouriteStatus(for photoId: String, with status: Bool) {
        userDefaults.set(status, forKey: photoId)
    }
    
    func getFavouriteStatus(for photoID: String) -> Bool {
        userDefaults.bool(forKey: photoID)
    }
    func addToFavourites(photoId: String) {
        if getFavourites().isEmpty {
            let favorites: [String] = []
            userDefaults.set(favorites, forKey: kFavourites)
        }
        var favourites = getFavourites()
        favourites.append(photoId)
        userDefaults.set(favourites, forKey: kFavourites)
    }
    func removeFromFavourites(photoId: String) {
        var favourites = getFavourites()
        favourites = favourites.filter { $0 != photoId}
        userDefaults.set(favourites, forKey: kFavourites)
    }
    func getFavourites() -> [String] {
        guard let favourites = userDefaults.stringArray(forKey: kFavourites) else { return [] }
        return favourites
    }
}
