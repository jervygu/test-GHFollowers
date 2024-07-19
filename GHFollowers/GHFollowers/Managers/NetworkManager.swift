//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import Foundation


enum APError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}

class NetworkManager {
    static let shared = NetworkManager()
    let baseUrl = "https://api.github.com"
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completion: @escaping([Follower]?, String?) -> Void) {
        let endpoint = baseUrl + "/users/\(username)/followers?per_page=30&page=\(page)"
        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            completion(nil, "This username created an invalid request, please try again.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(nil, "Unable to complete your request, please check internet connection")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid response from the server, please try again")
                return
            }
            
            guard let data = data else {
                completion(nil, "The data received from the server was invalid, please try again.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(followers, nil)
            } catch {
                completion(nil, "The data received from the server was invalid, please try again.")
            }
            
        }
        task.resume()
    }
}
