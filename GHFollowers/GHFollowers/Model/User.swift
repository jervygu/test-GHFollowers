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
    let nodeID: String
    let avatarUrl: String
    let gravatarId: String
    let url, htmlUrl, followersUrl: String
    let followingUrl, gistsUrl, starredUrl: String
    let subscriptionsUrl, organizationsUrl, reposUrl: String
    let eventsUrl: String
    let receivedEventsUrl: String
    let type: String
    let siteAdmin: Bool
    let name, company: String?
    let blog: String
    let location: String?
    let email: String?
    let hireable: Bool
    let bio, twitterUsername: String?
    let publicRepos, publicGists, followers, following: Int
    let createdAt, updatedAt: Date

//    enum CodingKeys: String, CodingKey {
//        case login, id
//        case nodeID = "node_id"
//        case avatarUrl = "avatar_url"
//        case gravatarId = "gravatar_id"
//        case url
//        case htmlURL = "html_url"
//        case followingUrl = "followers_url"
//        case followingURL = "following_url"
//        case gistsUrl = "gists_url"
//        case starredUrl = "starred_url"
//        case subscriptionsUrl = "subscriptions_url"
//        case organizationsUrl = "organizations_url"
//        case reposUrl = "repos_url"
//        case eventsUrl = "events_url"
//        case receivedEventsUrl = "received_events_url"
//        case type
//        case siteAdmin = "site_admin"
//        case name, company, blog, location, email, hireable, bio
//        case twitterUsername = "twitter_username"
//        case publicRepos = "public_repos"
//        case publicGists = "public_gists"
//        case followers, following
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
}
