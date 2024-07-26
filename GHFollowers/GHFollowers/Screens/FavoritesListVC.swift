//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import UIKit

// MARK: - GHFDataLoadingVC
class FavoritesListVC: GHFDataLoadingVC {
    
    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureClearButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        let subViews = view.subviews
//        
//        for view in subViews {
//            if let view = view as? GHFEmptyStateView {
//                view.removeFromSuperview()
//            }
//        }
//    }
    
    func configureClearButton() {
        let clearButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(clearButtonTapped))
        navigationItem.rightBarButtonItem = clearButton
    }
    
    @objc func clearButtonTapped() {
        let alert = UIAlertController(title: "Are you sure you want to clear favorites?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { action in
            print("Continue delete")
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        #warning("Favorites list VC table views contents bug in scrolling, come back to fix this")
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        // tableView.removeExcessCells() // doest need as of this writing, tableview doesnt show separator lines for empty cells
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
    }
    
    func getFavorites() {
        PersistenseManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Something went wrong!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func updateUI(with retrivedFavorites: [Follower]) {
        if retrivedFavorites.isEmpty {
            showEmptyStateView(with: "No Favorites? \nAdd one on the followers screen.", in: view)
        } else {
            favorites = retrivedFavorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as! FavoriteTableViewCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListVC(username: favorite.login)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        
        PersistenseManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                if self.favorites.isEmpty {
                    showEmptyStateView(with: "No Favorites? \nAdd one on the followers screen.", in: view)
                }
                return
            }
            
            self.presentGHFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
}
