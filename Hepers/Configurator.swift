//
//  Configurator.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 05.05.2022.
//

import UIKit

protocol ConfiguratorProtocol {
    func configurePhotosCollectionVC() -> PhotosCollectionViewController
    func configureFavouritesVC() -> FavouritesTableViewController
    func configureDetailVC(with photo: Photo) -> DetailViewController
}


final class Configurator: ConfiguratorProtocol {
    
    static let shared = Configurator()
    private init() {}

    func configurePhotosCollectionVC() -> PhotosCollectionViewController {
        let viewModel = PhotosCollectionViewModel(
            networkManager: NetworkManager.shared,
            dataManager: DataManager.shared
        )
        return PhotosCollectionViewController(
            with: viewModel,
            viewLayout: UICollectionViewFlowLayout(),
            configurator: self
        )
    }
    
    func configureFavouritesVC() -> FavouritesTableViewController {
        let viewModel = FavouritesTableViewModel(
            dataManager: DataManager.shared,
            networkManager: NetworkManager.shared
        )
        return FavouritesTableViewController(
            viewModel: viewModel,
            configurator: self
        )
    }
    
    func configureDetailVC(with photo: Photo) -> DetailViewController {
        let viewModel = DetailViewModel(photo: photo, dataManager: DataManager.shared)
        return DetailViewController(viewModel: viewModel)
    }
}
