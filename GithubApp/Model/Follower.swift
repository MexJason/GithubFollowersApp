//
//  Follower.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/14/22.
//

import Foundation

struct Follower: Codable {
    
    var login: String
    var avatarUrl: String //can use camel case, the decoder automatically formats it
    
    
}
