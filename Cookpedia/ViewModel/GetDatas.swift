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
    
    func getConnectedUserRecipes(userId: Int, completion: @escaping (Result<[RecipeConnectedUser], Error>) -> Void) {
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
                let recipes = try decoder.decode([RecipeConnectedUser].self, from: data)
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
                print("Error while fetching bookmark:", error.localizedDescription)
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
                    print("Bookmark exists:", jsonResult)
                    completion(.success(true))
                } else {
                    print("No bookmark found for userId \(userId) and recipeId \(recipeId)")
                    completion(.success(false))
                }
            } catch {
                print("Failed to parse JSON:", error.localizedDescription)
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getConnectedPublishedUserRecipes(userId: Int, published: Bool, completion: @escaping (Result<[RecipeConnectedUser], Error>) -> Void) {
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
                print("Error fetching user recipes:", error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                print("Invalid response or no data received")
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let recipes = try decoder.decode([RecipeConnectedUser].self, from: data)
                print("User recipes fetched successfully:", recipes)
                completion(.success(recipes))
            } catch {
                print("Failed to decode user recipes:", error.localizedDescription)
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
                print("Error while fetching published recipes count:", error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                print("Invalid response or no data received")
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let count = jsonResult?["count"] as? Int {
                    print("Published recipes count:", count)
                    completion(.success(count))
                } else {
                    print("No count field found in response")
                    completion(.success(0)) // Return 0 if the count field is missing
                }
            } catch {
                print("Failed to parse JSON:", error.localizedDescription)
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
                print("Error while fetching published recipes count:", error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                print("Invalid response or no data received")
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let count = jsonResult?["count"] as? Int {
                    print("Published recipes count:", count)
                    completion(.success(count))
                } else {
                    print("No count field found in response")
                    completion(.success(0)) // Return 0 if the count field is missing
                }
            } catch {
                print("Failed to parse JSON:", error.localizedDescription)
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
