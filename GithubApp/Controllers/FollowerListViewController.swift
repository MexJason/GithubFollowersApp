//
//  FollowerListViewController.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/13/22.
//

import UIKit



class FollowerListViewController: GHDataLoadingViewController {

    enum Section {
        case main
        
    }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page: Int = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        
        configureDataSource()
        
        configureSearchController()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    
    }
    
    func configureViewController() {
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        NetworkManager.shared.getUsers(for: username) { [weak self] result in
            guard let self = self else {return}
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else {return}
                    
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success", message: "User was successfully saved to favorites! 🎉", buttonTitle: "Ok")
                        return
                    }

                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        
        //collectionView.backgroundColor = .systemMint
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
        collectionView.delegate = self
        
    }
    
    func configureSearchController() {
        
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for user"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false  
        navigationItem.searchController = searchController
        
    }
    
    
    func getFollowers(username: String, page: Int) {
        
        showLoadingView()
        isLoadingFollowers = true
        
        // need to use a switch statment to handle result/error
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else {return}
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                if followers.count < 100 {self.hasMoreFollowers = false}
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty {
                    let message = "This user does not have any followers :(. Share a follow?"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                }
                self.updateData(on: followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Network Error", message: error.rawValue, buttonTitle: "Ok")
            }
    
            self.isLoadingFollowers = false
        }

    }
    
    func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.identifier, for: indexPath) as? FollowerCell else {return UICollectionViewCell()}
            cell.set(follower: follower)
            
            return cell
        })
        
    }

    func updateData(on followers: [Follower]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
        
        
    }
    
}

//MARK: -- Scroll

extension FollowerListViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingFollowers else {return}
            page += 1
            getFollowers(username: username, page: page)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // we have to account for filteredFollowers when user is searching
        var follower: Follower
        if isSearching {
            follower = filteredFollowers[indexPath.item]
        } else {
            follower = followers[indexPath.item]
        }
        
        let destinationVC = UserInfoViewController()
        destinationVC.username = follower.login
        destinationVC.delegate = self
        let navController = UINavigationController(rootViewController: destinationVC)
        
        present(navController, animated: true)
        
        
        
    }
    
    
}

//MARK: -- Search Bar

extension FollowerListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filterText = searchController.searchBar.text, !filterText.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filterText.lowercased()) }
        
        updateData(on: filteredFollowers)
        
    }
    
    
}

extension FollowerListViewController: UserInfoViewControllerDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        self.page = 1
        self.followers.removeAll()
        self.filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
        
    }

    
}
