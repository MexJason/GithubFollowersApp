//
//  GHFollowerItemViewController.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/17/22.
//

import UIKit

protocol GHFollowerItemViewControllerDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GHFollowerItemViewController: GHItemInfoViewController {
    
    weak var delegate: GHFollowerItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
        
    }
    
    
    private func configureItem() {
        itemOne.set(itemInfoType: .followers, with: user.followers)
        itemTwo.set(itemInfoType: .following, with: user.following)
        
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        super.actionButtonTapped()
        
        delegate?.didTapGetFollowers(for: user)
    }
    
}
