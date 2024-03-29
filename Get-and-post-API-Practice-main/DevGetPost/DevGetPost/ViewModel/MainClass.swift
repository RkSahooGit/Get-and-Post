//
//  MainClass.swift
//  DevGetPost
//
//  Created by Rakesh Kumar Sahoo on 30/01/24.
//

import Foundation

class UserPostService {
    
    static let shared = UserPostService()
    init() { }
    
    var urlString = "https://jsonplaceholder.typicode.com/posts"
    
    func getAllPosts(completion: @escaping(Result<[UserPost], UserPostServiceError>) -> Void) {
        let urlSession = URLSession.shared
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = urlSession.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.decodingError))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([UserPost].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    func createNewPost(completion: @escaping(Result<UserPost, UserCreatePostServiceError>) -> Void, with post: UserPost) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(post)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.encodingError))
        }
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.encodingError))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let createdPost = try JSONDecoder().decode(UserPost.self, from: data)
                completion(.success(createdPost))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
}
