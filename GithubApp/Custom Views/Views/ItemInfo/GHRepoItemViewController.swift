//
//  GHRepoItemViewController.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/17/22.
//

import UIKit

protocol GHRepoItemViewControllerDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class GHRepoItemViewController: GHItemInfoViewController {
    
    weak var delegate: GHRepoItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
        
    }
    
    
    private func configureItem() {
        itemOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemTwo.set(itemInfoType: .gists, with: user.publicGists)
        
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
        
    }
    
    override func actionButtonTapped() {
        super.actionButtonTapped()
        
        delegate?.didTapGitHubProfile(for: user)
        
    }
}
