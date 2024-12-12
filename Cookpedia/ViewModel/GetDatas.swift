//
//  GetDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/12/2024.
//

import Foundation

class APIGetRequest: ObservableObject {
    
    /*func getUserData(userId: Int, completion: @escaping (Result<User, Error>) -> Void) {
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
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(APIGetError.invalidResponse))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }*/
    
    func getConnectedUserUserData(userId: Int, completion: @escaping (Result<User, Error>) -> Void) {
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
                print("datas \(data)")
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
    
    func getConnectedUserRecipes(userId: Int, completion: @escaping (Result<[RecipeConnectedUser], Error>) -> Void) {
        let endpoint = "/recipes/recipes-connected-user/\(userId)"
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
                let recipes = try decoder.decode([RecipeConnectedUser].self, from: data)
                completion(.success(recipes))
            } catch {
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch for type \(type). Context: \(context)")
                    case .valueNotFound(let type, let context):
                        print("Value not found for type \(type). Context: \(context)")
                    case .keyNotFound(let key, let context):
                        print("Key '\(key)' not found. Context: \(context)")
                    case .dataCorrupted(let context):
                        print("Data corrupted. Context: \(context)")
                    @unknown default:
                        print("Unknown decoding error: \(error)")
                    }
                } else {
                    print("Unexpected error: \(error)")
                }
                completion(.failure(error))
            }
        }.resume()
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
