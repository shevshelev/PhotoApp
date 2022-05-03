//
//  FavouriteTableViewCell.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 03.05.2022.
//

import UIKit
import SDWebImage

class FavouriteTableViewCell: UITableViewCell {
    
    var favouriteCellViewModel: FavouriteTableViewModelCellProtocol! {
        didSet {
            setupUI()
        }
    }
    
    private lazy var favouriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favouriteImageView.image = nil
    }
    
    private func setupUI() {
        guard let imageURL = URL(string: favouriteCellViewModel.image) else { return }
        favouriteImageView.sd_setImage(with: imageURL)
        addSubview(activityIndicator)
        addSubview(favouriteImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            favouriteImageView.topAnchor.constraint(equalTo: self.topAnchor),
            favouriteImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            favouriteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            favouriteImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
