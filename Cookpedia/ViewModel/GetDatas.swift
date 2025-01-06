//
//  GetDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/12/2024.
//

import Foundation

class APIGetRequest: ObservableObject {
    
    func getUserDataFromUserId(userId: Int, completion: @escaping (Result<User, Error>) -> Void) {
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
    
    func getRecipesFromUserId(userId: Int, completion: @escaping (Result<[RecipeTitleCover], Error>) -> Void) {
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
    
    func getPublishedRecipesFromUserId(userId: Int, published: Bool, completion: @escaping (Result<[RecipeTitleCover], Error>) -> Void) {
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
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let recentRecipes = try decoder.decode([RecipeTitleCoverUser].self, from: data)
                completion(.success(recentRecipes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getConnectedUserRecipesWithDetails(userId: Int, completion: @escaping (Result<[RecipeTitleCoverUser], Error>) -> Void) {
        let endpoint = "/recipes/user-recipes-with-details/\(userId)"
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
                let recipes = try decoder.decode([RecipeTitleCoverUser].self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(APIGetError.decodingError))
            }
        }.resume()
    }
    
    func getRecipeDetails(recipeId: Int, completion: @escaping (Result<RecipeDetails, Error>) -> Void) {
        let endpoint = "/recipes/recipe-details/\(recipeId)"
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
            
            guard let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let recipeDetails = try decoder.decode(RecipeDetails.self, from: data)
                completion(.success(recipeDetails))
            } catch {
                completion(.failure(APIGetError.invalidResponse))
            }
        }.resume()
    }
    
    func isFollowing(followerId: Int, followedId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = "/users/is-following/\(followerId)/\(followedId)"
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
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let isFollowing = jsonResponse?["isFollowing"] as? Bool {
                    completion(.success(isFollowing))
                } else {
                    completion(.failure(APIGetError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getFollowingCount(userId: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        let endpoint = "/users/\(userId)/following"
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
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let followingCount = jsonResult?["followingCount"] as? Int {
                    completion(.success(followingCount))
                } else {
                    completion(.failure(APIGetError.decodingError))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getFollowersCount(userId: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        let endpoint = "/users/\(userId)/followers"
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
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let followersCount = jsonResult?["followersCount"] as? Int {
                    completion(.success(followersCount))
                } else {
                    completion(.failure(APIGetError.decodingError))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getFollowers(userId: Int, completion: @escaping (Result<[UserDetails], Error>) -> Void) {
        let endpoint = "/users/followers/\(userId)"
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
                let followers = try decoder.decode([UserDetails].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(APIGetError.decodingError))
            }
        }.resume()
    }
    
    func getFollowing(userId: Int, completion: @escaping (Result<[UserDetails], Error>) -> Void) {
        let endpoint = "/users/following/\(userId)"
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
                let following = try decoder.decode([UserDetails].self, from: data)
                completion(.success(following))
            } catch {
                completion(.failure(APIGetError.decodingError))
            }
        }.resume()
    }
    
    func getCommentsOrderAsc(forRecipeId recipeId: Int, completion: @escaping (Result<[CommentsDetails], Error>) -> Void) {
        let endpoint = "/comments/get-comments-from-recipe-id-order-asc/\(recipeId)"
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
                let comments = try decoder.decode([CommentsDetails].self, from: data)
                completion(.success(comments))
            } catch {
                completion(.failure(APIGetError.decodingError))
            }
        }.resume()
    }
    
    func getMostPopularRecipes(completion: @escaping (Result<[RecipeTitleCoverUser], Error>) -> Void) {
        let endpoint = "/recipes/most-popular-recipes"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create usersession request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Network errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check datas
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            // Decode datas
            do {
                let recipes = try JSONDecoder().decode([RecipeTitleCoverUser].self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getUsersByRecipeViews(completion: @escaping (Result<[UserDetails], Error>) -> Void) {
        let endpoint = "/users/recipe-views"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([UserDetails].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
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
