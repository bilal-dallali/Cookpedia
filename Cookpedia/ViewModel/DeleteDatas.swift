//
//  DeleteDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 26/12/2024.
//

import Foundation

class APIDeleteRequest: ObservableObject {
    
    private let networkService: NetworkService
    
    // Dependency Injection
    init(networkService: NetworkService = URLSession.shared) {
        self.networkService = networkService
    }
    
    func unfollowUser(followerId: Int, followedId: Int) async throws -> String {
        let endpoint = "/users/unfollow/\(followerId)/\(followedId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIDeleteError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (data, response) = try await networkService.request(request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorMessage = jsonResponse["error"] as? String {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            throw APIDeleteError.invalidResponse
        }

        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let message = jsonResponse["message"] as? String {
                return message
            } else {
                throw APIDeleteError.invalidResponse
            }
        } catch {
            throw APIDeleteError.decodingError
        }
    }
    
    func deleteRecipe(recipeId: Int) async throws -> String {
        let endpoint = "/recipes/delete-recipe/\(recipeId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIDeleteError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIDeleteError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            if let message = String(data: data, encoding: .utf8) {
                return message
            } else {
                throw APIDeleteError.invalidResponse
            }
        case 404:
            throw APIDeleteError.userNotFound
        case 500:
            throw APIDeleteError.serverError
        default:
            throw APIDeleteError.invalidResponse
        }
    }
    
    func deleteComment(commentId: Int) async throws {
        let endpoint = "/comments/delete-comment/\(commentId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIDeleteError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIDeleteError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return
        case 404:
            throw APIDeleteError.userNotFound
        case 500:
            throw APIDeleteError.serverError
        default:
            throw APIDeleteError.invalidResponse
        }
    }
    
    func unlikeComment(userId: Int, commentId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "/comments/unlike-comment"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["userId": userId, "commentId": commentId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
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
