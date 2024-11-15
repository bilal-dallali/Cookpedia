//
//  PostDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 28/10/2024.
//

import Foundation
import UIKit

class APIPostRequest: ObservableObject {
    let baseUrl = "http://localhost:3000/api"
    
    
    func registerUser(registration: UserRegistration, profilePicture: UIImage?, completion: @escaping (Result<Void, APIError>) -> ()) {
        let endpoint = "/users"
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
            if let key = key, let value = value as? CustomStringConvertible {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append(value.description.data(using: .utf8)!)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
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
                completion(.failure(APIError.serverError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let errorMessage = json["error"] as? String {
                    if errorMessage.contains("Email") {
                        completion(.failure(APIError.emailAlreadyExists))
                    } else if errorMessage.contains("Username") {
                        completion(.failure(APIError.usernameAlreadyExists))
                    } else if errorMessage.contains("Phone") {
                        completion(.failure(APIError.phoneNumberAlreadyExists))
                    } else {
                        completion(.failure(APIError.serverError))
                    }
                } else {
                    completion(.failure(APIError.invalidData))
                }
                return
            }
            
            completion(.success(()))
        }.resume()
    }
    
    /*func registerUser(registration: UserRegistration, profilePicture: UIImage?, completion: @escaping (Result<Void, APIError>) -> ()) {
        let endpoint = "/users"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(registration)
        request.httpBody = jsonData
        
        // Execute the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(APIError.serverError))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseDict = json as? [String: Any] else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                var errorMessageSent = false
                if let errorMessage = responseDict["error"] as? String {
                    if errorMessage.contains("Email") {
                        completion(.failure(APIError.emailAlreadyExists))
                        errorMessageSent = true
                    } else if errorMessage.contains("Username") {
                        completion(.failure(APIError.usernameAlreadyExists))
                        errorMessageSent = true
                    } else if errorMessage.contains("Phone") {
                        completion(.failure(APIError.phoneNumberAlreadyExists))
                        errorMessageSent = true
                    } else {
                        completion(.failure(APIError.serverError))
                        errorMessageSent = true
                    }
                }
                if !errorMessageSent, let message = responseDict["message"] as? String, message == "User created" {
                    completion(.success(()))
                } else if !errorMessageSent {
                    completion(.failure(APIError.invalidData))
                }
            } catch {
                completion(.failure(APIError.invalidData))
            }
        }.resume()
    }*/
    
    func loginUser(email: String, password: String, rememberMe: Bool, completion: @escaping (Result<String, APIError>) -> ()) {
        let endpoint = "/login"
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
                       let authToken = json["token"] as? String {
                        completion(.success(authToken)) // Pass the token back on success
                    } else {
                        completion(.failure(.invalidData)) // Handle case where token is missing
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
    func sendResetCode(email: String, completion: @escaping (Result<Void, APIError>) -> ()) {
        let endpoint = "/send-reset-code"
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
    func verifyResetCode(email: String, code: String, completion: @escaping (Result<Void, APIError>) -> ()) {
        let endpoint = "/verify-reset-code"
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
    
    func resetPassword(email: String, newPassword: String, resetCode: String , completion: @escaping (Result<Void, APIError>) -> ()) {
        let endpoint = "/reset-password"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "newPassword": newPassword, "resetCode": resetCode]
        do {
            request.httpBody = try JSONEncoder().encode(body)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let _ = error {
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
}

enum APIError: Error {
    case invalidUrl
    case invalidData
    case invalidCredentials
    case userNotFound
    case emailAlreadyExists
    case usernameAlreadyExists
    case phoneNumberAlreadyExists
    case serverError
    
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
        }
    }
}
