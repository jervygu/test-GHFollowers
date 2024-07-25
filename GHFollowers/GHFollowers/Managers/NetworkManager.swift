//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/19/24.
//

import UIKit

// MARK: - NetworkManager
class NetworkManager {
    
    static let shared       = NetworkManager()
    private let baseUrl     = "https://api.github.com"
    let perPage: Int        = 100
    let cache               = NSCache<NSString, UIImage>()
    
    let decoder             = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - getFollowers
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
                let followers = try self.decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        task.resume()
    }
    
    // MARK: - getFollowersZZ
    func getFollowersZZ(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseUrl + "/users/\(username)/followers?per_page=\(perPage)&page=\(page)"
        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            throw GHFError.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHFError.invalidResponse
        }
        
        
        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw GHFError.invalidData
        }
    }
    
    // MARK: - getUserInfo
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
                let user = try self.decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        task.resume()
    }
    
    // MARK: - getUserInfoZZ
    func getUserInfoZZ(for username: String) async throws -> User {
        let endpoint = baseUrl + "/users/\(username)"
        
        guard let url = URL(string: endpoint) else {
            throw GHFError.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHFError.invalidResponse
        }
        
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GHFError.invalidData
        }
    }
    
    // MARK: - downloadImage
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
    
    // MARK: - downloadImageZZ
    func downloadImageZZ(from urlString: String) async -> UIImage? {
        //        let cacheKey = NSString(string: urlString)
        //        if let image = cache.object(forKey: cacheKey) { return image }
        //        guard let url = URL(string: urlString) else { return nil }
        //        do {
        //            let (data, _) = try await URLSession.shared.data(from: url)
        //            guard let image = UIImage(data: data) else { return nil }
        //            cache.setObject(image, forKey: cacheKey)
        //            return image
        //        } catch {
        //            return nil
        //        }
        
        // avoid do/catch block
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        guard let url = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let image = UIImage(data: data) else {
            return nil
        }
        cache.setObject(image, forKey: cacheKey)
        return image
    }
}
