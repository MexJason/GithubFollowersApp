//
//  GHTabBarController.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/22/22.
//

import UIKit

class GHTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = .darkGray
        setViewControllers([createSearchNavigationController(), createFavoriteNavigationController()], animated: true)
        
        
    }
    
    func createSearchNavigationController() -> UINavigationController {
        let searchVC = SearchViewController()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
        
    }
    
    func createFavoriteNavigationController() -> UINavigationController {
        let favoriteVC = FavoritesViewController()
        favoriteVC.title = "Favorites"
        favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoriteVC)
        
    }


}
