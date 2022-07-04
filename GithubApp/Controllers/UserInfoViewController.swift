//
//  UserInfoViewController.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/17/22.
//

import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoViewController: GHDataLoadingViewController {

    weak var delegate: UserInfoViewControllerDelegate?

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    
    let dateLabel = GHBodyLabel(textAlignment: .center)
    
    //let itemViews: [UIView] = [] you can use an array of views to iterate and add layouts in a for loop

    var username: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureScrollView()
        layoutViews()
        getUserInfo()
        
        
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 650)
        ])
        
        contentView.pinToEdges(of: scrollView)
        
        
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
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
        
        
    }
    
    func layoutViews() {
        contentView.addSubviews(headerView, itemViewOne, itemViewTwo, dateLabel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let itemHeight: CGFloat = 140
        
        NSLayoutConstraint.activate([
        
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            itemViewOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            itemViewOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: 20),
            itemViewTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            itemViewTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
        
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: 20),
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
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

extension UserInfoViewController: GHFollowerItemViewControllerDelegate, GHRepoItemViewControllerDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {return presentGFAlertOnMainThread(title: "Invalid URL", message: "The url of this user is invalid. Try again.", buttonTitle: "Ok")}
   
        presentSafariVC(with: url)
        
    }
    
    func didTapGetFollowers(for user: User) {
        
        if user.followers > 0 {
            delegate?.didRequestFollowers(for: user.login)
            dismissVC()
        } else {
            presentGFAlertOnMainThread(title: "No Followers", message: "This user has no followers. Awwww dang 😭", buttonTitle: "Tragic")
            return
        }
        
        
        
    }
    
    
    
    
}
