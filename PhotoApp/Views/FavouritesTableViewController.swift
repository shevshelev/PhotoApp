//
//  FavouritesTableViewController.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 29.04.2022.
//

import UIKit

class FavouritesTableViewController: UITableViewController {
    
    private var favouritesTableViewModel: FavouritesTableViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        
        favouritesTableViewModel = FavouritesTableViewModel()
        favouritesTableViewModel.fetchPhotos {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favouritesTableViewModel.updatePhotos {
            self.tableView.reloadData()
        }
    }
    
    private func setupNavBar() {
        navigationItem.title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func setupTableView() {
        tableView.register(FavouriteTableViewCell.self, forCellReuseIdentifier: "FavouriteCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesTableViewModel.numberOfRows()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = favouritesTableViewModel.favouritesCellViewModel(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.reuseID, for: indexPath) as? FavouriteTableViewCell else { return UITableViewCell() }
        cell.favouriteCellViewModel = cellViewModel
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showAlert(for: indexPath)
//            favouritesTableViewModel.deleteFormFavourites(at: indexPath)
//            favouritesTableViewModel.updatePhotos {
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
        }
    }

// MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = favouritesTableViewModel.favouritesCellViewModel(at: indexPath)
        return UIScreen.main.bounds.width * cellViewModel.aspectRatio
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.detailsViewModel = favouritesTableViewModel.detailsViewModel(at: indexPath)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FavouritesTableViewController {
    private func showAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "Are you sure?",
            message: "Are you sure you want to remove the photo from your favorites?",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] _ in
            self.favouritesTableViewModel.deleteFormFavourites(at: indexPath)
            self.favouritesTableViewModel.updatePhotos {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
