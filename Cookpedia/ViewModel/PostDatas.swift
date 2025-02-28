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
    
    func registerUser(registration: UserRegistration, profilePicture: UIImage?, rememberMe: Bool, completion: @escaping (Result<(token: String, id: Int), APIPostError>) -> ()) {
        let endpoint = "/users/registration"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(.invalidUrl))
            return
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

                // Convert specific types before adding it to the body
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
        
        // Execute the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(APIPostError.serverError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidData))
                return
            }
            
            switch httpResponse.statusCode {
            case 201:
                // Decode token from response
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                   let token = json["token"] as? String, let id = json["userId"] as? Int {
                    completion(.success((token: token, id: id)))
                    
                } else {
                    completion(.failure(.invalidData))
                }
            case 400:
                // Decode the error message from the backend
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let errorMessage = json["error"] as? String {
                    if errorMessage.contains("Email") {
                        completion(.failure(.emailAlreadyExists))
                    } else if errorMessage.contains("Username") {
                        completion(.failure(.usernameAlreadyExists))
                    } else if errorMessage.contains("Phone number") {
                        completion(.failure(.phoneNumberAlreadyExists))
                    } else {
                        completion(.failure(.invalidData))
                        // Default case for unknown errors
                    }
                } else {
                    completion(.failure(.invalidData))
                }
                
            case 500:
                completion(.failure(.serverError))
            default:
                completion(.failure(.serverError))
            }
            
        }.resume()
    }
    
    func loginUser(email: String, password: String, rememberMe: Bool, completion: @escaping (Result<(token: String, id: Int), APIPostError>) -> ()) {
        let endpoint = "/users/login"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Include the "rememberMe" option in the request body
        let loginDetails = ["email": email, "password": password, "rememberMe": rememberMe] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: loginDetails, options: [])
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.serverError))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidData))
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    // Decode the token from the response data
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                       let token = json["token"] as? String, let id = json["id"] as? Int {
                        completion(.success((token: token, id: id)))
                    } else {
                        completion(.failure(.invalidData))
                    }
                case 401:
                    completion(.failure(.invalidCredentials))
                case 404:
                    completion(.failure(.userNotFound))
                default:
                    completion(.failure(.serverError))
                }
            }.resume()
        } catch {
            completion(.failure(.invalidData))
        }
    }
    
    // Function to send the reset code request
    func sendResetCode(email: String, completion: @escaping (Result<Void, APIPostError>) -> ()) {
        let endpoint = "/users/send-reset-code"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email]
        do {
            request.httpBody = try JSONEncoder().encode(body)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.serverError))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(.userNotFound))
                    return
                }
                completion(.success(()))
            }.resume()
        } catch {
            completion(.failure(.invalidData))
        }
    }
    
    // Function to verify the reset code
    func verifyResetCode(email: String, code: String, completion: @escaping (Result<Void, APIPostError>) -> ()) {
        let endpoint = "/users/verify-reset-code"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "code": code]
        do {
            request.httpBody = try JSONEncoder().encode(body)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.serverError))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(.invalidData))
                    return
                }
                completion(.success(()))
            }.resume()
        } catch {
            completion(.failure(.invalidData))
        }
    }
    
    func resetPassword(email: String, newPassword: String, resetCode: String, rememberMe: Bool, completion: @escaping (Result<(token: String, id: Int), APIPostError>) -> ()) {
        let endpoint = "/users/reset-password"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add the parameters in the body
        let body = ["email": email, "newPassword": newPassword, "resetCode": resetCode, "rememberMe": rememberMe] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.serverError))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidData))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    // Decode JSON for response
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                       let token = json["token"] as? String, let id = json["id"] as? Int {
                        completion(.success((token: token, id: id)))
                    } else {
                        completion(.failure(.invalidData))
                    }
                case 400:
                    if let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let errorMessage = json["error"] as? String {
                        if errorMessage.contains("Invalid reset code") {
                            completion(.failure(.invalidCredentials))
                        } else {
                            completion(.failure(.invalidData))
                        }
                    } else {
                        completion(.failure(.invalidData))
                    }
                case 500:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.serverError))
                }
            }.resume()
        } catch {
            completion(.failure(.invalidData))
        }
    }
    
    func uploadRecipe(recipe: RecipeRegistration, recipeCoverPicture1: UIImage?, recipeCoverPicture2: UIImage?, instructionImages: [(UIImage, String)], isPublished: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/recipes/upload"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add fields for text
        func appendField(_ name: String, value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append(value.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
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
        
        // Add images to the body request
        func appendImage(_ image: UIImage?, withName name: String, fileName: String) {
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Add cover images
        appendImage(recipeCoverPicture1, withName: "recipeCoverPicture1", fileName: "recipeCoverPicture1.jpg")
        appendImage(recipeCoverPicture2, withName: "recipeCoverPicture2", fileName: "recipeCoverPicture2.jpg")
        
        // Add instructions images
        for (image, fileName) in instructionImages {
            appendImage(image, withName: "instructionImages", fileName: fileName)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                completion(.failure(NSError(domain: "Invalid Response", code: -1, userInfo: nil)))
                return
            }
            
            completion(.success("Recipe uploaded successfully"))
        }.resume()
    }
    
    func toggleBookmark(userId: Int, recipeId: Int, isBookmarked: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = isBookmarked ? "/recipes/bookmark" : "/recipes/bookmark"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isBookmarked ? "DELETE" : "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "userId": userId,
            "recipeId": recipeId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }
    
    func followUser(followerId: Int, followedId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/users/follow"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
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
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201,
                  let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let message = jsonResponse?["message"] as? String ?? "Followed successfully"
                completion(.success(message))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func incrementViews(recipeId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/recipes/increment-views/\(recipeId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIGetError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            if let data = data, let message = String(data: data, encoding: .utf8) {
                completion(.success(message))
            } else {
                completion(.failure(APIGetError.invalidResponse))
            }
        }.resume()
    }
    
    func postComment(comment: CommentsPost, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/comments/add-comment"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIPostError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestBody = try JSONEncoder().encode(comment)
            request.httpBody = requestBody
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201,
                  let data = data else {
                completion(.failure(APIPostError.invalidResponse))
                return
            }
            
            if let responseMessage = String(data: data, encoding: .utf8) {
                completion(.success(responseMessage))
            } else {
                completion(.failure(APIPostError.decodingError))
            }
        }.resume()
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
