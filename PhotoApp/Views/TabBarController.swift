//
//  TabBarController.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 29.04.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    private lazy var photosVC: UINavigationController = {
        setupVC(
            VC: PhotosCollectionViewController(
                collectionViewLayout: UICollectionViewFlowLayout()
            ),
            title: "Photos",
            imageName: "photo.tv"
        )
    }()
    
    private lazy var favouritesVC: UINavigationController = {
        setupVC(
            VC: FavouritesTableViewController(),
            title: "Favourites",
            imageName: "heart.rectangle"
        )
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([photosVC, favouritesVC], animated: false)
    }
    
    private func setupVC(VC: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: VC)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        return navigationController
    }
}

