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
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], ErrorMessage>) -> Void) {
        
        let endPoint = "\(baseURL)\(username)/followers?per_page=\(perPageFollowers)&page=\(page)"
        
        guard let url = URL(string: endPoint) else {
            //completion(nil, .invalidUsername)
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                //completion(nil, .unableToComplete)
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                //completion(nil, .invalidResponse)
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                //completion(nil, .invalidResponse)
                completion(.failure(.invalidResponse))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                //completion(followers, nil)
                completion(.success(followers))
            } catch {
                
                //completion(nil, .invalidData)
                completion(.failure(.invalidData))
            }
            

            
        }
        
        task.resume()
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
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
            

            
        }
        
        task.resume()
    }
    
    
}
