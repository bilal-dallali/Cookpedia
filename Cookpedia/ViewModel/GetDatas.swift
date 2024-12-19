//
//  GetDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/12/2024.
//

import Foundation

class APIGetRequest: ObservableObject {
    
    func getConnectedUserUserData(userId: Int, completion: @escaping (Result<User, Error>) -> Void) {
        let endpoint = "/users/profile/\(userId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(APIGetError.decodingError))
            }
        }.resume()
    }
    
    func getConnectedUserRecipes(userId: Int, completion: @escaping (Result<[RecipeTitleCover], Error>) -> Void) {
        let endpoint = "/recipes/fetch-all-recipes-from-user/\(userId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let recipes = try decoder.decode([RecipeTitleCover].self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getBookmark(userId: Int, recipeId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = "/recipes/bookmark/\(userId)/\(recipeId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                
                // Check result
                if let jsonResult = jsonResult, !jsonResult.isEmpty {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getConnectedPublishedUserRecipes(userId: Int, published: Bool, completion: @escaping (Result<[RecipeTitleCover], Error>) -> Void) {
        let publishedValue = published ? 1 : 0
        let endpoint = "/recipes/fetch-user-published-recipes/\(userId)/\(publishedValue)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let recipes = try decoder.decode([RecipeTitleCover].self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(APIGetError.decodingError))
            }
        }.resume()
    }
    
    func getPublishedRecipesCount(userId: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        let endpoint = "/recipes/published-recipes-count/\(userId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let count = jsonResult?["count"] as? Int {
                    completion(.success(count))
                } else {
                    completion(.success(0))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getDraftRecipesCount(userId: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        let endpoint = "/recipes/draft-recipes-count/\(userId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let count = jsonResult?["count"] as? Int {
                    completion(.success(count))
                } else {
                    completion(.success(0))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
//    func getSavedRecipes(userId: Int, completion: @escaping (Result<[RecipeTitleCoverUser], Error>) -> Void) {
//        let endpoint = "/recipes/bookmarked-recipes/\(userId)"
//        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
//            completion(.failure(APIGetError.invalidUrl))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
//                  let data = data else {
//                completion(.failure(APIGetError.invalidResponse))
//                return
//            }
//            
//            do {
//                let recipes = try JSONDecoder().decode([RecipeTitleCoverUser].self, from: data)
//                completion(.success(recipes))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
    func getSavedRecipes(userId: Int, completion: @escaping (Result<[RecipeTitleCoverUser], Error>) -> Void) {
        let endpoint = "/recipes/bookmarked-recipes/\(userId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let savedRecipes = try decoder.decode([RecipeTitleCoverUser].self, from: data)
                completion(.success(savedRecipes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getAllRecentRecipes(completion: @escaping (Result<[RecipeTitleCoverUser], Error>) -> Void) {
        let endpoint = "/recipes/recent-recipes"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
//                let recipes = try JSONDecoder().decode([RecipeTitleCoverUser].self, from: data)
//                completion(.success(recipes))
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let recentRecipes = try decoder.decode([RecipeTitleCoverUser].self, from: data)
                completion(.success(recentRecipes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum APIGetError: Error {
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
