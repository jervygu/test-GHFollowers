//
//  Follower.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import Foundation

// MARK: - Follower
struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String

//    enum CodingKeys: String, CodingKey {
//        case login
//        case avatarUrl = "avatar_url"
//    }
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(login)
//    }
}
