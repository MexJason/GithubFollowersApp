//
//  PersistenceManager.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/20/22.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}


enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }

    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (ErrorMessage?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.alreadyExist)
                        return
                    }
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                completion(saveFavorites(favorites: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }     
    }
    
    
    static func retrieveFavorites(completion: @escaping (Result<[Follower], ErrorMessage>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func saveFavorites(favorites: [Follower]) -> ErrorMessage? {
        
        do {
            let enconder = JSONEncoder()
            let encodedFavorites = try enconder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites )
            return nil // return nil became no error
        } catch {
            return .unableToFavorite
        }
    }
    
}
