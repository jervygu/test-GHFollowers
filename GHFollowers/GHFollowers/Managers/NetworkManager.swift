//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import UIKit

// MARK: - APError
enum APError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}

// MARK: - NetworkManager
class NetworkManager {
    
    static let shared       = NetworkManager()
    private let baseUrl     = "https://api.github.com"
    let perPage: Int        = 100
    let cache               = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completion: @escaping(Result<[Follower], GHFError>) -> Void) {
        let endpoint = baseUrl + "/users/\(username)/followers?per_page=\(perPage)&page=\(page)"
        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        /// Other way of making URL using URLComponents
        //        var components = URLComponents()
        //        components.scheme       = "https"
        //        components.host         = "api.github.com"
        //        components.path         = "/users/\(username)/followers"
        //        components.queryItems   = [
        //            URLQueryItem(name: "per_page", value: String(perPage)),
        //            URLQueryItem(name: "page", value: String(page))
        //        ]
        //
        //        guard let url = components.url else {
        //            completion(.failure(.invalidUsername))
        //            return
        //        }
        //        print("components.url \(components.url!)")
        
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
    
    func getUserInfo(for username: String, completion: @escaping(Result<User, GHFError>) -> Void) {
        let endpoint = baseUrl + "/users/\(username)"
        
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
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        task.resume()
    }
}
