//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import UIKit


enum APError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completion: @escaping(Result<[Follower], GHFError>) -> Void) {
        let endpoint = baseUrl + "/users/\(username)/followers?per_page=30&page=\(page)"
        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        task.resume()
    }
}
