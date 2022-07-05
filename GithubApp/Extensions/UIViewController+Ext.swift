//
//  UIViewController+Ext.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/13/22.
//

import UIKit
import SafariServices


extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = GHAlertViewController(title: title, message: message, alert: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true)
        }
    }
    
    func presentDefaultError() {
        
        let alert = GHAlertViewController(title: "There was an issue.", message: "We were unable to complete your task at this time. Please try again.", alert: "Ok")
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        self.present(alert, animated: true)
    }
    
    func presentSafariVC(with url: URL) {
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
        
    }
    
}
