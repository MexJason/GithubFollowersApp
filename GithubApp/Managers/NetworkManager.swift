//
//  NetworkManager.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/14/22.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.github.com/users/"
    let perPageFollowers = 100
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}

//    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], ErrorMessage>) -> Void) {
//
//        let endPoint = "\(baseURL)\(username)/followers?per_page=\(perPageFollowers)&page=\(page)"
//
//        guard let url = URL(string: endPoint) else {
//            //completion(nil, .invalidUsername)
//            completion(.failure(.invalidUsername))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//
//            if let _  = error {
//                //completion(nil, .unableToComplete)
//                completion(.failure(.unableToComplete))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                //completion(nil, .invalidResponse)
//                completion(.failure(.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                //completion(nil, .invalidResponse)
//                completion(.failure(.invalidResponse))
//                return
//            }
//
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let followers = try decoder.decode([Follower].self, from: data)
//                //completion(followers, nil)
//                completion(.success(followers))
//            } catch {
//
//                //completion(nil, .invalidData)
//                completion(.failure(.invalidData))
//            }
//        }
//
//        task.resume()
//    }
    
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        
        let endPoint = "\(baseURL)\(username)/followers?per_page=\(perPageFollowers)&page=\(page)"
        
        guard let url = URL(string: endPoint) else {
            throw ErrorMessage.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
    
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ErrorMessage.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let followers = try decoder.decode([Follower].self, from: data)
            return followers
        } catch {
            throw ErrorMessage.invalidData
        }
   
    }
    
    func getUsers(for username: String, completion: @escaping (Result<User, ErrorMessage>) -> Void) {
        
        let endPoint = "\(baseURL)\(username)"
        
        guard let url = URL(string: endPoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        let keyCache = NSString(string: urlString)
        if let image = cache.object(forKey: keyCache) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
            
        }
        // not handling errors, the place holder will handle the errors and will show too many images. doesnt make sense to throw errors to user
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                completion(nil)
                return
            }
        
            guard let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: keyCache)
            
            completion(image)
        }
        task.resume()
    }
    
}
