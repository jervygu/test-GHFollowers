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
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        // setting UITabBar tintColor
        UITabBar.appearance().tintColor = .systemGreen
        
        viewControllers = [createSearchNC(), createFavoritesNC()]
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let appearance = createNavigationAppearance()
        
        let nav = UINavigationController(rootViewController: searchVC)
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        
        return nav
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC = FavoritesListVC()
        favoritesListVC.title = "Favorites"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let appearance = createNavigationAppearance()
        
        let nav = UINavigationController(rootViewController: favoritesListVC)
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        
        return nav
    }
    
    func createNavigationAppearance(with backgroundColor: UIColor = .systemBackground) -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        
        // setting UINavigationBar tintColor
        UINavigationBar.appearance().tintColor = .systemGreen
        
        return appearance
    }
    
}
