//
//  GHFError.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import Foundation

enum GHFError: String, Error {
    case invalidUsername = "This username created an invalid request, please try again."
    case unableToComplete = "Unable to complete your request, please check internet connection"
    case invalidResponse = "Invalid response from the server, please try again"
    case invalidData = "The data received from the server was invalid, please try again."
}
