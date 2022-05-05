//
//  TabBarController.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 29.04.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let configurator: ConfiguratorProtocol
    
    private lazy var photosVC: UINavigationController = {
        setupVC(
            VC: configurator.configurePhotosCollectionVC(),
            title: "Photos",
            imageName: "photo.tv"
        )
    }()
    
    private lazy var favouritesVC: UINavigationController = {
        setupVC(
            VC: configurator.configureFavouritesVC(),
            title: "Favourites",
            imageName: "heart.rectangle"
        )
    }()
    
    init(_ configurator: ConfiguratorProtocol) {
        self.configurator = configurator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

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

