//
//  GHDataLoadingViewController.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/22/22.
//

import UIKit

class GHDataLoadingViewController: UIViewController {

    var containerView: UIView!

    func showLoadingView() {
        
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        // alpha will start at 0 then be animated to higher alpha
        
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
        
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyState = GHEmptyStateView(message: message)
        emptyState.frame = view.bounds
        view.addSubview(emptyState)
    }

}
