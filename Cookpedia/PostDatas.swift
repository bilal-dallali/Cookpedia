//
//  PostDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/04/2023.
//

import Foundation

struct UserRegistration: Codable {
    let username: String
    let email: String
    let password: String
    let country: String
    let level: String
    let salad: Bool
    let egg: Bool
    let soup: Bool
    let meat: Bool
    let chicken: Bool
    let seafood: Bool
    let burger: Bool
    let pizza: Bool
    let sushi: Bool
    let rice: Bool
    let bread: Bool
    let fruit: Bool
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let nutFree: Bool
    let dairyFree: Bool
    let lowCarb: Bool
    let peanutFree: Bool
    let keto: Bool
    let soyFree: Bool
    let rawFood: Bool
    let lowFat: Bool
    let halal: Bool
    let fullName: String
    let phoneNumber: String
    let gender: String
    let date: String
    let city: String
    let profilePictureUrl: String
}

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
}

enum APIError: Error {
    case invalidUrl
    case invalidData
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
