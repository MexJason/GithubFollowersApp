//
//  GHAlertContainerView.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/22/22.
//

import UIKit

class GHAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContainerView() {
        
    
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        
    }
}
