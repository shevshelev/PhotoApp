//
//  DataManager.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 02.05.2022.
//

import Foundation

class DataManager {
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
    func addToFavourites(photoURL: String) {
        var favourites = userDefaults.stringArray(forKey: kFavourites)
        favourites?.append(photoURL)
        userDefaults.set(favourites, forKey: kFavourites)
    }
    func getFavourites() -> [String]? {
        userDefaults.stringArray(forKey: kFavourites)
    }
}
