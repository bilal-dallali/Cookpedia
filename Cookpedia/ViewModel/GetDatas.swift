//
//  GetDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/12/2024.
//

import Foundation
import FirebasePerformance

class APIGetRequest: ObservableObject {
    
    private let networkService: NetworkService
    
    // Dependency Injection
    init(networkService: NetworkService = URLSession.shared) {
        self.networkService = networkService
    }
    
    // Get user connected data
    func getUserDataFromUserId(userId: Int) async throws -> User {
        let trace = Performance.startTrace(name: "get_user_data_from_user_id")

        let endpoint = "/users/profile/\(userId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                trace?.stop()
                return user
            } catch {
                trace?.incrementMetric("decoding_error", by: 1)
                trace?.stop()
                throw APIGetError.decodingError
            }
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.invalidResponse
        }
    }
    
    // Get recipes from the connected user
    func getRecipesFromUserId(userId: Int) async throws -> [RecipeTitleCover] {
        let trace = Performance.startTrace(name: "get_recipes_from_user_id")

        let endpoint = "/recipes/fetch-all-recipes-from-user/\(userId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let recipes = try decoder.decode([RecipeTitleCover].self, from: data)
                trace?.stop()
                return recipes
            } catch {
                trace?.incrementMetric("decoding_error", by: 1)
                trace?.stop()
                throw APIGetError.decodingError
            }
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get bookmarked recipes from the connected user
    func getBookmark(userId: Int, recipeId: Int) async throws -> Bool {
        let trace = Performance.startTrace(name: "get_bookmark")

        let endpoint = "/recipes/bookmark/\(userId)/\(recipeId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]

                guard let json = jsonResult else {
                    trace?.incrementMetric("decoding_error", by: 1)
                    trace?.stop()
                    throw APIGetError.decodingError
                }

                trace?.stop()
                return !json.isEmpty
            } catch {
                trace?.incrementMetric("decoding_error", by: 1)
                trace?.stop()
                throw APIGetError.decodingError
            }
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get public recipes
    func getPublishedRecipesFromUserId(userId: Int, published: Bool) async throws -> [RecipeTitleCover] {
        let trace = Performance.startTrace(name: "get_published_recipes")
        let publishedValue = published ? 1 : 0
        let endpoint = "/recipes/fetch-user-published-recipes/\(userId)/\(publishedValue)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)
            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }
            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode([RecipeTitleCover].self, from: data)
            trace?.stop()
            return result
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get the published recipe count
    func getPublishedRecipesCount(userId: Int) async throws -> Int {
        let trace = Performance.startTrace(name: "get_published_recipes_count")
        let endpoint = "/recipes/published-recipes-count/\(userId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)
            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }
            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let count = jsonResult?["count"] as? Int else {
                trace?.incrementMetric("invalid_json", by: 1)
                trace?.stop()
                throw APIGetError.decodingError
            }

            trace?.stop()
            return count
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get draft recipe from the userId
    func getDraftRecipesCount(userId: Int) async throws -> Int {
        let trace = Performance.startTrace(name: "get_draft_recipes_count")
        let endpoint = "/recipes/draft-recipes-count/\(userId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)
            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }
            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let count = jsonResult?["count"] as? Int else {
                trace?.incrementMetric("invalid_json", by: 1)
                trace?.stop()
                throw APIGetError.decodingError
            }

            trace?.stop()
            return count
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get the recipes you've saved
    func getSavedRecipes(userId: Int) async throws -> [RecipeTitleCoverUser] {
        let trace = Performance.startTrace(name: "get_saved_recipes")
        let endpoint = "/recipes/bookmarked-recipes/\(userId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)
            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }
            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let savedRecipes = try decoder.decode([RecipeTitleCoverUser].self, from: data)

            trace?.stop()
            return savedRecipes
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get all public recipes from the most recent one to the most ancient one
    func getAllRecentRecipes() async throws -> [RecipeTitleCoverUser] {
        let trace = Performance.startTrace(name: "get_all_recent_recipes")
        
        let endpoint = "/recipes/recent-recipes"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }
        
        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let recipes = try decoder.decode([RecipeTitleCoverUser].self, from: data)
                trace?.stop()
                return recipes
            } catch {
                trace?.incrementMetric("decoding_error", by: 1)
                trace?.stop()
                throw APIGetError.decodingError
            }
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get recipes details from connected user
    func getConnectedUserRecipesWithDetails(userId: Int) async throws -> [RecipeTitleCoverUser] {
        let trace = Performance.startTrace(name: "get_connected_user_recipes_with_details")
        let endpoint = "/recipes/user-recipes-with-details/\(userId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let recipes = try decoder.decode([RecipeTitleCoverUser].self, from: data)
            trace?.stop()
            return recipes
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    
    // Get followed user recipes
    func getFollowedUsersRecipes(userId: Int) async throws -> [RecipeTitleCoverUser] {
        let trace = Performance.startTrace(name: "get_followed_users_recipes")
        let endpoint = "/recipes/followed-users-recipes/\(userId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let recipes = try decoder.decode([RecipeTitleCoverUser].self, from: data)
            trace?.stop()
            return recipes
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get recipes details from recipeId
    func getRecipeDetails(recipeId: Int) async throws -> RecipeDetails {
        let trace = Performance.startTrace(name: "get_recipe_details")
        
        let endpoint = "/recipes/recipe-details/\(recipeId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.stop()
            throw APIGetError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await networkService.request(request)
            
            if let httpResponse = response as? HTTPURLResponse {
                trace?.incrementMetric("http_status_\(httpResponse.statusCode)", by: 1)
                
                guard httpResponse.statusCode == 200 else {
                    trace?.stop()
                    throw APIGetError.invalidResponse
                }
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let recipeDetails = try decoder.decode(RecipeDetails.self, from: data)
            
            trace?.stop()
            return recipeDetails
            
        } catch {
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Know if a follower is used
    func isFollowing(followerId: Int, followedId: Int) async throws -> Bool {
        let trace = Performance.startTrace(name: "is_following")
        let endpoint = "/users/is-following/\(followerId)/\(followedId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let isFollowing = json?["isFollowing"] as? Bool ?? false
            trace?.stop()
            return isFollowing
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get the number of person you follow
    func getFollowingCount(userId: Int) async throws -> Int {
        let trace = Performance.startTrace(name: "get_following_count")
        let endpoint = "/users/\(userId)/following"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let followingCount = json?["followingCount"] as? Int else {
                trace?.incrementMetric("missing_field", by: 1)
                trace?.stop()
                throw APIGetError.decodingError
            }

            trace?.stop()
            return followingCount
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get the number of people who follows you
    func getFollowersCount(userId: Int) async throws -> Int {
        let trace = Performance.startTrace(name: "get_followers_count")
        let endpoint = "/users/\(userId)/followers"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let followersCount = json?["followersCount"] as? Int else {
                trace?.incrementMetric("missing_field", by: 1)
                trace?.stop()
                throw APIGetError.decodingError
            }

            trace?.stop()
            return followersCount
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // get the list of followers from a userId
    func getFollowers(userId: Int) async throws -> [UserDetails] {
        let trace = Performance.startTrace(name: "get_followers")
        let endpoint = "/users/followers/\(userId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let users = try decoder.decode([UserDetails].self, from: data)

            trace?.stop()
            return users
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get following persons from a userId
    func getFollowing(userId: Int) async throws -> [UserDetails] {
        let trace = Performance.startTrace(name: "get_following")
        let endpoint = "/users/following/\(userId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let users = try decoder.decode([UserDetails].self, from: data)

            trace?.stop()
            return users
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get comments from the most recent to the oldest
    func getCommentsOrderDesc(forRecipeId recipeId: Int) async throws -> [CommentsDetails] {
        let trace = Performance.startTrace(name: "get_comments_desc")
        let endpoint = "/comments/get-comments-from-recipe-id-order-desc/\(recipeId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let comments = try decoder.decode([CommentsDetails].self, from: data)

            trace?.stop()
            return comments
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    
    // Get comment by the number of likes
    func getCommentsByLikes(forRecipeId recipeId: Int) async throws -> [CommentsDetails] {
        let trace = Performance.startTrace(name: "get_comments_by_likes")
        let endpoint = "/comments/get-comments-from-recipe-id-order-by-likes/\(recipeId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let comments = try decoder.decode([CommentsDetails].self, from: data)

            trace?.stop()
            return comments
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get recipes from the most popular to the least popular
    func getMostPopularRecipes() async throws -> [RecipeTitleCoverUser] {
        let trace = Performance.startTrace(name: "get_most_popular_recipes")
        let endpoint = "/recipes/most-popular-recipes"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let recipes = try JSONDecoder().decode([RecipeTitleCoverUser].self, from: data)
            trace?.stop()
            return recipes
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    
    // Get user by the views his recipes have
    func getUsersByRecipeViews() async throws -> [UserDetails] {
        let trace = Performance.startTrace(name: "get_users_by_recipe_views")
        let endpoint = "/users/recipe-views"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let users = try JSONDecoder().decode([UserDetails].self, from: data)
            trace?.stop()
            return users
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get recipes by a recommendation process (random for now)
    func getRecommendations() async throws -> [RecipeTitleCoverUser] {
        let trace = Performance.startTrace(name: "get_recommendations")
        let endpoint = "/recipes/recommendations"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let recipes = try JSONDecoder().decode([RecipeTitleCoverUser].self, from: data)
            trace?.stop()
            return recipes
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get recipes from the one which is the most searched
    func getMostSearchesRecipes() async throws -> [RecipeTitleCoverUser] {
        let trace = Performance.startTrace(name: "get_most_searches_recipes")
        let endpoint = "/recipes/most-searches-recipes"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            let recipes = try JSONDecoder().decode([RecipeTitleCoverUser].self, from: data)
            trace?.stop()
            return recipes
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Get comments likes number
    func getCommentLikes(commentId: Int) async throws -> Int {
        let endpoint = "/comments/comment-likes/\(commentId)"
        
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
            if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let likeCount = jsonResponse["likeCount"] as? Int {
                return likeCount
            } else {
                throw APIGetError.decodingError
            }
        } catch {
            throw APIGetError.decodingError
        }
    }
    
    // Check if a comment is liked
    func isCommentLiked(userId: Int, commentId: Int) async throws -> Bool {
        let trace = Performance.startTrace(name: "is_comment_liked")
        let endpoint = "/comments/is-comment-liked/\(userId)/\(commentId)"

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let isLiked = jsonResponse["isLiked"] as? Bool {
                trace?.stop()
                return isLiked
            } else {
                trace?.incrementMetric("invalid_json", by: 1)
                trace?.stop()
                throw APIGetError.decodingError
            }
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
    // Check the session at the launch of the app
    func checkUserSession(token: String) async throws -> Int? {
        let trace = Performance.startTrace(name: "check_session")
        
        guard let url = URL(string: "\(baseUrl)/users/check-session") else {
            trace?.incrementMetric("invalid_url", by: 1)
            trace?.stop()
            throw APIGetError.invalidUrl
        }

        guard let metric = HTTPMetric(url: url, httpMethod: .get) else {
            trace?.incrementMetric("metric_init_failed", by: 1)
            trace?.stop()
            throw APIGetError.invalidResponse
        }

        metric.start()

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await networkService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
                trace?.setValue(Int64(httpResponse.statusCode), forMetric: "http_status")
            }

            metric.responsePayloadSize = Int(Int64(data.count))
            metric.stop()

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                trace?.incrementMetric("invalid_response", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }

            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let isActive = jsonResponse["active"] as? Bool {
                trace?.stop()
                return isActive ? jsonResponse["userId"] as? Int : nil
            } else {
                trace?.incrementMetric("invalid_json", by: 1)
                trace?.stop()
                throw APIGetError.invalidResponse
            }
        } catch {
            trace?.incrementMetric("request_failed", by: 1)
            metric.stop()
            trace?.stop()
            throw APIGetError.decodingError
        }
    }
    
}

enum APIGetError: Error, LocalizedError {
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
