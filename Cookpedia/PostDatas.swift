//
//  PostDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/04/2023.
//

import Foundation

//(username: String, email: String, password: String, country: String, level: String, salad: Bool, egg: Bool, soup: Bool, meat: Bool, chicken: Bool, seafood: Bool, burger: Bool, pizza: Bool, sushi: Bool, rice: Bool, bread: Bool, fruit: Bool, vegetarian: Bool, vegan: Bool, glutenFree: Bool, nutFree: Bool, dairyFree: Bool, lowCarb: Bool, peanutFree: Bool, keto: Bool, soyFree: Bool, rawFood: Bool, lowFat: Bool, halal: Bool, fullName: String, phoneNumber: String, gender: String, date: String, city: String, profilePictureUrl: String)

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
    
    func registerUser(registration: UserRegistration, completion: @escaping (Result<Bool, Error>) -> ()) {
        let endpoint = "/users"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIError.invalidUrl))
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
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 400 {
                    completion(.failure(APIError.userAlreadyExists))
                    return
                }
                completion(.success(true))
            }.resume()
        } catch {
            completion(.failure(APIError.invalidData))
        }
    }
}

enum APIError: Error {
    case invalidUrl
    case invalidData
    case userAlreadyExists
}
