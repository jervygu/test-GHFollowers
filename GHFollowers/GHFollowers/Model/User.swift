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
//    let nodeId: String
    let avatarUrl: String
//    let gravatarId: String
//    let url, followersUrl: String
//    let followingUrl, gistsUrl, starredUrl: String
//    let subscriptionsUrl, organizationsUrl, reposUrl: String
//    let eventsUrl: String
//    let receivedEventsUrl: String
//    let type: String
//    let siteAdmin: Bool
    let htmlUrl: String
    var name, company: String?
    var blog: String?
    var location: String?
    var email: String?
//    let hireable: Bool
    var bio, twitterUsername: String?
    let publicRepos, publicGists, followers, following: Int
    let createdAt, updatedAt: Date
    
    
}
