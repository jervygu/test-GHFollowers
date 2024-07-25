//
//  User.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import Foundation

// MARK: - User
struct User: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    let htmlUrl: String
    var name, company: String?
    var blog: String?
    var location: String?
    var email: String?
    var bio, twitterUsername: String?
    let publicRepos, publicGists, followers, following: Int
    let createdAt, updatedAt: Date
}
