//
//  GetDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/12/2024.
//

import Foundation

class APIGetRequest: ObservableObject {
    
    private let networkService: NetworkService
    
    // Dependency Injection
    init(networkService: NetworkService = URLSession.shared) {
        self.networkService = networkService
    }
    
    func getUserDataFromUserId(userId: Int) async throws -> User {
        let endpoint = "/users/profile/\(userId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIGetError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIGetError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(User.self, from: data)
        } catch {
            throw APIGetError.decodingError
        }
    }
    
    func getRecipesFromUserId(userId: Int) async throws -> [RecipeTitleCover] {
        let endpoint = "/recipes/fetch-all-recipes-from-user/\(userId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIGetError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIGetError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([RecipeTitleCover].self, from: data)
        } catch {
            throw APIGetError.decodingError
        }
    }
    
    func getBookmark(userId: Int, recipeId: Int) async throws -> Bool {
        let endpoint = "/recipes/bookmark/\(userId)/\(recipeId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIGetError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIGetError.invalidResponse
        }
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            
            return jsonResult?.isEmpty == false
        } catch {
            throw APIGetError.decodingError
        }
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
    
    func getCommentsOrderDesc(forRecipeId recipeId: Int, completion: @escaping (Result<[CommentsDetails], Error>) -> Void) {
        let endpoint = "/comments/get-comments-from-recipe-id-order-desc/\(recipeId)"
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
    
    func getCommentsByLikes(forRecipeId recipeId: Int, completion: @escaping (Result<[CommentsDetails], Error>) -> Void) {
        let endpoint = "/comments/get-comments-from-recipe-id-order-by-likes/\(recipeId)"
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
    
    func getRecommendations(completion: @escaping (Result<[RecipeTitleCoverUser], Error>) -> Void) {
        let endpoint = "/recipes/recommendations"
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
                let recipes = try JSONDecoder().decode([RecipeTitleCoverUser].self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getMostSearchesRecipes(completion: @escaping (Result<[RecipeTitleCoverUser], Error>) -> Void) {
        let endpoint = "/recipes/most-searches-recipes"
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
    
    func getCommentLikes(commentId: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        let endpoint = "/comments/comment-likes/\(commentId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let likeCount = jsonResponse["likeCount"] as? Int else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            completion(.success(likeCount))
        }.resume()
    }
    
    func isCommentLiked(userId: Int, commentId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = "/comments/is-comment-liked/\(userId)/\(commentId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            // Log brut response
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw server response:", responseString)
            }
            
            // Extract isLiked from JSON
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let isLiked = jsonResponse["isLiked"] as? Bool {
                    completion(.success(isLiked))
                } else {
                    completion(.failure(APIGetError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func checkUserSession(token: String, completion: @escaping (Result<Int?, Error>) -> Void) {
        let endpoint = "/users/check-session"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

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
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let isActive = jsonResponse["active"] as? Bool {
                    let userId = isActive ? jsonResponse["userId"] as? Int : nil
                    completion(.success(userId))
                } else {
                    completion(.failure(APIGetError.invalidResponse))
                }
            } catch {
                completion(.failure(APIGetError.decodingError))
            }
        }.resume()
    }
    
}

enum APIGetError: Error {
    case invalidUrl
    case invalidResponse
    case decodingError
    case serverError
    case userNotFound
    
    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .decodingError:
            return "Decoding error"
        case .serverError:
            return "Server error"
        case .userNotFound:
            return "User not found"
        }
    }
}
