//
//  NetworkManager.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 29.04.2022.
//

import Foundation

enum ImageRequestType {
    case random
    case search
    case single
}


class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchImages(type: ImageRequestType, with searchTerm: String?, or photoId: String?, completion: @escaping (Any?) -> ()) {
        imageRequest(for: type, with: searchTerm, or: photoId ) { data, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            let decode: Any
            switch type {
            case .random:
                decode = self.decodeJSON(from: data, in: [Photo].self) as? [Photo]
            case .search:
                decode = self.decodeJSON(from: data, in: SearchResults.self) as? SearchResults
            case .single:
                decode = self.decodeJSON(from: data, in: Photo.self) as? Photo
            }
            completion(decode)
        }
    }
    
    private func decodeJSON<T: Decodable>(from data: Data?, in type:T.Type) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func imageRequest(for type: ImageRequestType, with searchTerm: String?, or photoId: String?, completion: @escaping (Data?, Error?) -> Void) {
        let parameters = prepareParameters(for: type, searchTerm: searchTerm)
        guard let url = getUrl(for: type, with: parameters, or: photoId ) else { return }
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareParameters(for type: ImageRequestType, searchTerm: String?) -> [String: String] {
        var parameters: [String: String] = [:]
        parameters["client_id"] = "gER7wfAQOHtij7HMyHEhhgcHwMg518C5_KPvM8zuYSk"
        switch type {
        case .random:
            parameters["count"] = "30"
        case .search:
            parameters["query"] = searchTerm
            parameters["page"] = "1"
            parameters["per_page"] = "30"
        case .single:
            break
        }
        return parameters
    }
    
    
    
    private func getUrl(for type: ImageRequestType, with params: [String: String], or photoId: String?) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        switch type {
        case .random:
            components.path = "/photos/random"
        case .search:
            components.path = "/search/photos"
        case .single:
            components.path = "/photos/\(photoId!)"
        }
        
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
 
}
