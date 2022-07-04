//
//  GHItemInfoViewController.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/17/22.
//

import UIKit



class GHItemInfoViewController: UIViewController {

    
    let stackView = UIStackView()
    let itemOne = GHItemInfoView()
    let itemTwo = GHItemInfoView()
    
    let actionButton = GHButton()

    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackground()
        configureStackView()
        layout()
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {
        
    }

    private func configureBackground() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
        
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(itemOne)
        stackView.addArrangedSubview(itemTwo)
    }
    
    private func layout() {
        view.addSubviews(stackView, actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            
        
        ])
        
    }

}
