//
//  UIViewController+Ext.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/13/22.
//

import UIKit

extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = GHAlertViewController(title: title, message: message, alert: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true)
        }
    }
    
}
