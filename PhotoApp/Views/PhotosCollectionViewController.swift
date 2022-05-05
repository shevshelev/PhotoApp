//
//  PhotosCollectionViewController.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 29.04.2022.
//

import UIKit

final class PhotosCollectionViewController: UICollectionViewController {
    
    private let configurator: ConfiguratorProtocol
    private let photoCollectionViewModel: PhotosCollectionViewModelProtocol
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    init(with viewModel: PhotosCollectionViewModelProtocol, viewLayout: UICollectionViewLayout, configurator: ConfiguratorProtocol) {
        photoCollectionViewModel = viewModel
        self.configurator = configurator
        super.init(collectionViewLayout: viewLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRandomPhoto()
        setupCollectionView()
        setupNavBar()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
    private func setupNavBar() {
        navigationItem.title = "Photos"
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func setupSubviews() {
        let subViews = [activityIndicator]
        subViews.forEach { view.addSubview($0) }
    }
    
    private func showRandomPhoto() {
        photoCollectionViewModel.fetchPhoto(type: .random) { [unowned self] in
            activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoCollectionViewModel.numberOfItems()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCellViewModel = photoCollectionViewModel.photoCellViewModel(at: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellViewModel.reuseID, for: indexPath)
                as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.photoCellViewModel = photoCellViewModel
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = configurator.configureDetailVC(
            with: photoCollectionViewModel.getPhoto(at: indexPath)
        )
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellViewModel = photoCollectionViewModel.photoCellViewModel(at: indexPath)
        let w = UIScreen.main.bounds.width / 2 - 13
        let h = cellViewModel.aspectRatio * w
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}

// MARK: - UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        activityIndicator.startAnimating()
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [unowned self] _ in
            if !searchText.isEmpty {
                self.photoCollectionViewModel.fetchPhoto(type: .search(searchTerm: searchText)) { [unowned self] in
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            } else {
                showRandomPhoto()
            }
        })
    }
}


