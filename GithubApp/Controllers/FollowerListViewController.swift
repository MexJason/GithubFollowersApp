//
//  FollowerListViewController.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/13/22.
//

import UIKit

class FollowerListViewController: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
       
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, errorMsg in
            guard let followers = followers else {
                return self.presentGFAlertOnMainThread(title: "Network Error", message: errorMsg!.rawValue, buttonTitle: "Ok")
            }
            
            print(followers.count)
            print(followers)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    


}
