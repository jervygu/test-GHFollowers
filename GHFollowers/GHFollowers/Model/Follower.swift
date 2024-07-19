//
//  Follower.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import Foundation

// MARK: - Follower
struct Follower: Codable {
    let login: String
    let avatarUrl: String

//    enum CodingKeys: String, CodingKey {
//        case login
//        case avatarUrl = "avatar_url"
//    }
}
