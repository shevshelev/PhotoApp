//
//  Photo.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 29.04.2022.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [Photo]
}

struct Photo: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: [URls.RawValue:String]
    let photoDescription: String?
    let altDescription: String?
    let user: User
    
    enum URls: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case urls
        case photoDescription = "description"
        case altDescription = "alt_description"
        case user
    }
}

struct User: Decodable {
    let userName: String?
}
