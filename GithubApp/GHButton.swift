//
//  GHButton.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/13/22.
//

import UIKit

class GHButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor, title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = color
        self.setTitle(title, for: .normal)
        configure()
        
    }
    
    private func configure() {
    
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        
        
    }
   
    
}
