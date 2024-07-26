//
//  GHFTabBarController.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/24/24.
//

import UIKit

// MARK: - UITabBarController
class GHFTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().tintColor = .systemGreen
        
        viewControllers = [createSearchNC(), createFavoritesNC()]
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let nav = UINavigationController(rootViewController: searchVC)
        return nav
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC = FavoritesListVC()
        favoritesListVC.title = "Favorites"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let nav = UINavigationController(rootViewController: favoritesListVC)
        return nav
    }
    
}
