//
//  ErrorMessage.swift
//  GithubApp
//
//  Created by Jason Dubon on 6/14/22.
//

import Foundation

enum ErrorMessage: String, Error {
    
    case invalidUsername = "This username created an invalid request"
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from server was invalid. Please try again."
    
    case unableToFavorite = "There was an error adding this user to favorites. Please Try Again."
    case alreadyExist = "This is user is already in your favorites :)"
}

