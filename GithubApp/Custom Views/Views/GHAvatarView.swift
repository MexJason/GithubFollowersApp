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
    
    func downloadImage(from urlString: String) {
    
        let keyCache = NSString(string: urlString)
        if let image = cache.object(forKey: keyCache) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        // not handling errors, the place holder will handle the errors and will show too many images. doesnt make sense to throw errors to user
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {return}
            
            if error != nil {return}
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
            
            guard let data = data else {return}
            
            guard let image = UIImage(data: data) else {return}
            
            self.cache.setObject(image, forKey: keyCache)
            
            DispatchQueue.main.async {
                self.image = image
            }
            
            
        }
        
        task.resume()
    }
    
    
}
