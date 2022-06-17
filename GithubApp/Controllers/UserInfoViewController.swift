//
//  UserInfoViewController.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/17/22.
//

import UIKit
import SafariServices

protocol UserInfoViewControllerDelegate: class {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoViewController: UIViewController {

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    
    let dateLabel = GHBodyLabel(textAlignment: .center)
    
    //let itemViews: [UIView] = [] you can use an array of views to iterate and add layouts in a for loop

    var username: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        layoutViews()
        getUserInfo()
        
        
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func getUserInfo() {
        NetworkManager.shared.getUsers(for: username) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func configureUIElements(with user: User) {
        let repoVC = GHRepoItemViewController(user: user)
        repoVC.delegate = self
        
        let followerVC = GHFollowerItemViewController(user: user)
        followerVC.delegate = self
        
        self.addChildVC(childVC: GHHeaderInfoViewController(user: user), to: self.headerView)
        self.addChildVC(childVC: repoVC, to: self.itemViewOne)
        self.addChildVC(childVC: followerVC, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
        
        
    }
    
    func layoutViews() {
        view.addSubview(headerView)
        view.addSubview(itemViewOne)
        view.addSubview(itemViewTwo)
        view.addSubview(dateLabel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let itemHeight: CGFloat = 140
        
        NSLayoutConstraint.activate([
        
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: 20),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
        
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: 20),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
            dateLabel.centerXAnchor.constraint(equalTo: itemViewTwo.centerXAnchor)
            
        ])
        
        
    }
    
    
    func addChildVC(childVC: UIViewController, to containerView: UIView) {
    
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
        
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    

}

extension UserInfoViewController: UserInfoViewControllerDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {return presentGFAlertOnMainThread(title: "Invalid URL", message: "The url of this user is invalid. Try again.", buttonTitle: "Ok")}
   
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
        
    }
    
    func didTapGetFollowers(for user: User) {
        
    }
    
    
    
    
}
