//
//  DeleteDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 26/12/2024.
//

import Foundation

class APIDeleteRequest: ObservableObject {
    
    func unfollowUser(followerId: Int, followedId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/users/unfollow/\(followerId)/\(followedId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                print("Invalid response: \(response.debugDescription)")
                completion(.failure(APIDeleteError.invalidResponse))
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = jsonResponse?["message"] as? String {
                    completion(.success(message))
                } else if let error = jsonResponse?["error"] as? String {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error])))
                } else {
                    completion(.failure(APIDeleteError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func deleteRecipe(recipeId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        
        let endpoint = "/recipes/delete-recipe/\(recipeId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIDeleteError.invalidResponse))
                return
            }
            
            if let data = data, let message = String(data: data, encoding: .utf8) {
                completion(.success(message))
            } else {
                completion(.failure(APIDeleteError.invalidResponse))
            }
        }.resume()
    }
    
    func deleteComment(commentId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "/comments/delete-comment/\(commentId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIDeleteError.invalidResponse))
                return
            }
            
            completion(.success(()))
        }.resume()
    }
}

enum APIDeleteError: Error {
    case invalidUrl
    case invalidResponse
    case decodingError
    
    var localizedDescription: String {
        switch self {
            case .invalidUrl:
                return "Invalid URL"
            case .invalidResponse:
                return "Invalid response"
            case .decodingError:
                return "Decoding error"
        }
    }
}
