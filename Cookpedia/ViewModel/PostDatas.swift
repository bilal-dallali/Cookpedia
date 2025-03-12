//
//  PostDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 28/10/2024.
//

import Foundation
import UIKit

let baseUrl = "http://localhost:3000/api"

class APIPostRequest: ObservableObject {
    
    private let networkService: NetworkService
    
    // Dependency Injection
    init(networkService: NetworkService = URLSession.shared) {
        self.networkService = networkService
    }
    
    func registerUser(registration: UserRegistration, profilePicture: UIImage?, rememberMe: Bool) async throws -> (token: String, id: Int) {
        let endpoint = "/users/registration"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPostError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Define the boundary for the multipart form-data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Start building the multipart body
        var body = Data()
        
        // Add each field of UserRegistration as a form-data field
        for (key, value) in Mirror(reflecting: registration).children {
            if let key = key {
                var fieldValue: String
                
                // Convert specific types before adding them to the body
                if let boolValue = value as? Bool {
                    fieldValue = boolValue ? "1" : "0"
                } else if let value = value as? CustomStringConvertible {
                    fieldValue = value.description
                } else {
                    continue
                }
                
                // Add to body
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append(fieldValue.data(using: .utf8)!)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        // Add rememberMe parameter
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"rememberMe\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(rememberMe ? "true" : "false")\r\n".data(using: .utf8)!)
        
        // Add profile picture if provided
        if let profilePicture = profilePicture, let imageData = profilePicture.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"profilePicture\"; filename=\"profile_picture.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // End the multipart form-data body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Assign the body to the request
        request.httpBody = body
        
        // Execute the request using the injected network service
        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIPostError.invalidData
        }
        
        switch httpResponse.statusCode {
        case 201:
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let token = json["token"] as? String, let id = json["userId"] as? Int {
                return (token: token, id: id)
            } else {
                throw APIPostError.invalidData
            }
        case 400:
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let errorMessage = json["error"] as? String {
                if errorMessage.contains("Email") {
                    throw APIPostError.emailAlreadyExists
                } else if errorMessage.contains("Username") {
                    throw APIPostError.usernameAlreadyExists
                } else if errorMessage.contains("Phone number") {
                    throw APIPostError.phoneNumberAlreadyExists
                } else {
                    throw APIPostError.invalidData
                }
            } else {
                throw APIPostError.invalidData
            }
        case 500:
            throw APIPostError.serverError
        default:
            throw APIPostError.serverError
        }
    }
    
    // Function to login
    func loginUser(email: String, password: String, rememberMe: Bool) async throws -> (token: String, id: Int) {
        let endpoint = "/users/login"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPostError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginDetails: [String: Any] = [
            "email": email,
            "password": password,
            "rememberMe": rememberMe
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginDetails, options: [])
        } catch {
            throw APIPostError.invalidData
        }

        let (data, response) = try await networkService.request(request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIPostError.invalidData
        }

        switch httpResponse.statusCode {
        case 200:
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let token = json["token"] as? String,
               let id = json["id"] as? Int {
                return (token: token, id: id)
            } else {
                throw APIPostError.invalidData
            }
        case 401:
            throw APIPostError.invalidCredentials
        case 404:
            throw APIPostError.userNotFound
        default:
            throw APIPostError.serverError
        }
    }
    
    // Function to send the reset code request
    func sendResetCode(email: String) async throws {
        let endpoint = "/users/send-reset-code"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPostError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw APIPostError.invalidData
        }

        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIPostError.invalidData
        }

        switch httpResponse.statusCode {
        case 200:
            return
        case 404:
            throw APIPostError.userNotFound
        default:
            throw APIPostError.serverError
        }
    }
    
    // Function to verify the reset code
    func verifyResetCode(email: String, code: String) async throws {
        let endpoint = "/users/verify-reset-code"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPostError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "code": code]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw APIPostError.invalidData
        }

        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIPostError.invalidData
        }

        switch httpResponse.statusCode {
        case 200:
            return
        case 400:
            throw APIPostError.invalidData
        case 404:
            throw APIPostError.userNotFound
        default:
            throw APIPostError.serverError
        }
    }
    
    func resetPassword(email: String, newPassword: String, resetCode: String, rememberMe: Bool) async throws -> (token: String, id: Int) {
        let endpoint = "/users/reset-password"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPostError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "newPassword": newPassword,
            "resetCode": resetCode,
            "rememberMe": rememberMe
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            throw APIPostError.invalidData
        }

        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIPostError.invalidData
        }

        switch httpResponse.statusCode {
        case 200:
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let token = json["token"] as? String,
               let id = json["id"] as? Int {
                return (token, id)
            } else {
                throw APIPostError.invalidData
            }
        case 400:
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let errorMessage = json["error"] as? String {
                if errorMessage.contains("Invalid reset code") {
                    throw APIPostError.invalidCredentials
                } else {
                    throw APIPostError.invalidData
                }
            } else {
                throw APIPostError.invalidData
            }
        case 500:
            throw APIPostError.serverError
        default:
            throw APIPostError.serverError
        }
    }
    
    func uploadRecipe(recipe: RecipeRegistration, recipeCoverPicture1: UIImage?, recipeCoverPicture2: UIImage?, instructionImages: [(UIImage, String)], isPublished: Bool) async throws -> String {
        
        let endpoint = "/recipes/upload"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Function to add textfield to the multipart/formdata
        func appendField(_ name: String, value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append(value.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Adding textfield
        appendField("userId", value: "\(recipe.userId)")
        appendField("title", value: recipe.title)
        appendField("recipeCoverPictureUrl1", value: recipe.recipeCoverPictureUrl1 ?? "")
        appendField("recipeCoverPictureUrl2", value: recipe.recipeCoverPictureUrl2 ?? "")
        appendField("description", value: recipe.description)
        appendField("cookTime", value: recipe.cookTime)
        appendField("serves", value: recipe.serves)
        appendField("origin", value: recipe.origin)
        appendField("ingredients", value: recipe.ingredients)
        appendField("instructions", value: recipe.instructions)
        appendField("isPublished", value: "\(isPublished)")
        
        // Function to add an image to the format multipart/form-data
        func appendImage(_ image: UIImage?, withName name: String, fileName: String) {
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Adding cover images
        appendImage(recipeCoverPicture1, withName: "recipeCoverPicture1", fileName: "recipeCoverPicture1.jpg")
        appendImage(recipeCoverPicture2, withName: "recipeCoverPicture2", fileName: "recipeCoverPicture2.jpg")
        
        // Adding instructions image
        for (image, fileName) in instructionImages {
            appendImage(image, withName: "instructionImages", fileName: fileName)
        }
        
        // End format multipart/form-data
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // Execute request with async await
        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid Response", code: -1, userInfo: nil)
        }
        
        // Handle HTTP errors
        switch httpResponse.statusCode {
        case 201:
            return "Recipe uploaded successfully"
        case 400:
            throw NSError(domain: "Invalid Request", code: 400, userInfo: nil)
        case 500:
            throw NSError(domain: "Server Error", code: 500, userInfo: nil)
        default:
            throw NSError(domain: "Unexpected Error", code: httpResponse.statusCode, userInfo: nil)
        }
    }
    
    func toggleBookmark(userId: Int, recipeId: Int, isBookmarked: Bool) async throws {
        let endpoint = "/recipes/bookmark"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPostError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isBookmarked ? "DELETE" : "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "userId": userId,
            "recipeId": recipeId
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (_, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIPostError.invalidResponse
        }
    }
    
    func followUser(followerId: Int, followedId: Int) async throws -> String {
        let endpoint = "/users/follow"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPostError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "followerId": followerId,
            "followedId": followedId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            throw APIPostError.invalidData
        }
        
        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIPostError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 201:
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let message = jsonResponse["message"] as? String {
                return message
            } else {
                return "Followed successfully"
            }
            
        case 400:
            throw APIPostError.invalidData
        case 404:
            throw APIPostError.userNotFound
        case 500:
            throw APIPostError.serverError
        default:
            throw APIPostError.invalidResponse
        }
    }
    
    func incrementViews(recipeId: Int) async throws -> String {
        let endpoint = "/recipes/increment-views/\(recipeId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPostError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIPostError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            if let message = String(data: data, encoding: .utf8) {
                return message
            } else {
                throw APIPostError.invalidData
            }
        case 400:
            throw APIPostError.invalidData
        case 404:
            throw APIPostError.userNotFound
        case 500:
            throw APIPostError.serverError
        default:
            throw APIPostError.invalidResponse
        }
    }
    
    func postComment(comment: CommentsPost) async throws -> String {
        let endpoint = "/comments/add-comment"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPostError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestBody = try JSONEncoder().encode(comment)
            request.httpBody = requestBody
        } catch {
            throw APIPostError.invalidData
        }
        
        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIPostError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 201:
            if let responseMessage = String(data: data, encoding: .utf8) {
                return responseMessage
            } else {
                throw APIPostError.decodingError
            }
        case 400:
            throw APIPostError.invalidData
        case 404:
            throw APIPostError.userNotFound
        case 500:
            throw APIPostError.serverError
        default:
            throw APIPostError.invalidResponse
        }
    }
    
    func likeComment(userId: Int, commentId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "/comments/like-comment"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
    
    func incrementRecipeSearch(recipeId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/recipes/increment-searches/\(recipeId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Execute request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Invalid Response", code: -1, userInfo: nil)))
                return
            }

            completion(.success("Recipe search count incremented successfully"))
        }.resume()
    }
}

enum APIPostError: Error {
    case invalidUrl
    case invalidData
    case invalidCredentials
    case userNotFound
    case emailAlreadyExists
    case usernameAlreadyExists
    case phoneNumberAlreadyExists
    case serverError
    case requestFailed
    case invalidResponse
    case decodingError
    
    var localizedDescription: String {
        switch self {
            case .invalidUrl:
                return "Invalid URL"
            case .invalidData:
                return "Invalid data"
            case .invalidCredentials:
                return "Incorrect password"
            case .userNotFound:
                return "User not found"
            case .emailAlreadyExists:
                return "Email already exists"
            case .usernameAlreadyExists:
                return "Username already exists"
            case .phoneNumberAlreadyExists:
                return "Phone number already exists"
            case .serverError:
                return "Server error"
            case .requestFailed:
                return "Request failed"
            case .invalidResponse:
                return "Invalid response"
            case .decodingError:
                return "Decoding error"
        }
    }
}
