//
//  GHAvatarView.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/14/22.
//

import UIKit

class GHAvatarView: UIImageView {

    let placeholderImage = UIImage(named: "avatar-placeholder-dark")
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
        
        
    }

    
    
}
