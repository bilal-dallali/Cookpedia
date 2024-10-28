//
//  PostDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 28/10/2024.
//

import Foundation

class APIRequest {
    let baseUrl = "http://localhost:3000/api"
    
    func registerUser(registration: UserRegistration, completion: @escaping (Result<Void, APIError>) -> ()) {
        let endpoint = "/users"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(.invalidUrl))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONEncoder().encode(registration)
            request.httpBody = jsonData
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
        } catch {
            completion(.failure(APIError.invalidData))
        }
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping (Result<Void, APIError>) -> ()) {
        let endpoint = "/login"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginDetails = ["email": email, "password": password]
        do {
            let jsonData = try JSONEncoder().encode(loginDetails)
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
                    completion(.success(()))
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
