//
//  ErrorMessage.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/14/22.
//

import Foundation

enum ErrorMessage: String {
    
    case invalidUsername = "This username created an invalid request"
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from server was invalid. Please try again."
    
    
}

