//
//  ViewController.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/13/22.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        let vc1 = SearchViewController()
        let vc2 = FavoritesViewController()
        
        setViewControllers([vc1, vc2], animated: true)
    }


}

