//
//  PhotoCollectionViewCell.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 29.04.2022.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var photoCellViewModel: PhotoCollectionViewModelCellProtocol! {
        didSet {
            setupUI()
        }
    }

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let favouriteMark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = .systemRed
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    private func setupUI() {
        guard let imageURL = URL(string: photoCellViewModel.image) else { return }
        photoImageView.sd_setImage(with: imageURL)
        photoCellViewModel.isFavorite.bind { [unowned self] value in
            setupFavouriteMarkAlpha(with: value)
        }
        addSubviews([
            photoImageView,
            favouriteMark
        ])
        setupConstraints()
    }
        
    private func setupFavouriteMarkAlpha(with status: Bool) {
        favouriteMark.alpha = status ? 1 : 0
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            favouriteMark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8),
            favouriteMark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8)
        ])
    }
    private func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
