//
//  PutDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 23/12/2024.
//

import Foundation
import UIKit

class APIPutRequest: ObservableObject {
    
    func updateUserProfile(userId: Int, user: EditUser, profilePicture: UIImage?, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/users/edit-profile/\(userId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIPutError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        func appendField(_ name: String, value: String?) {
            guard let value = value else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        func appendImage(_ image: UIImage?, withName name: String) {
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(name).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        appendField("fullName", value: user.fullName)
        appendField("username", value: user.username)
        appendField("description", value: user.description)
        appendField("youtube", value: user.youtube)
        appendField("facebook", value: user.facebook)
        appendField("twitter", value: user.twitter)
        appendField("instagram", value: user.instagram)
        appendField("website", value: user.website)
        appendField("city", value: user.city)
        appendField("country", value: user.country)
        appendField("profilePictureUrl", value: user.profilePictureUrl)
        
        appendImage(profilePicture, withName: "profilePicture")
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIPutError.invalidResponse))
                return
            }
            
            completion(.success("Profile updated successfully"))
        }.resume()
    }
    
    func updateRecipe(recipeId: Int, updatedRecipe: RecipeRegistration, recipeCoverPicture1: UIImage?, recipeCoverPicture2: UIImage?, instructionImages: [(UIImage, String)], isPublished: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/recipes/update-recipe/\(recipeId)"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            completion(.failure(APIPutError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Helper Functions
        func appendField(_ name: String, value: String?) {
            guard let value = value else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        func appendImage(_ image: UIImage?, withName name: String, fileName: String) {
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Append recipe fields
        appendField("userId", value: "\(updatedRecipe.userId)")
        appendField("title", value: updatedRecipe.title)
        appendField("recipeCoverPictureUrl1", value: updatedRecipe.recipeCoverPictureUrl1 ?? "")
        appendField("recipeCoverPictureUrl2", value: updatedRecipe.recipeCoverPictureUrl2 ?? "")
        appendField("description", value: updatedRecipe.description)
        appendField("cookTime", value: updatedRecipe.cookTime)
        appendField("serves", value: updatedRecipe.serves)
        appendField("origin", value: updatedRecipe.origin)
        appendField("ingredients", value: updatedRecipe.ingredients)
        appendField("instructions", value: updatedRecipe.instructions)
        appendField("isPublished", value: "\(isPublished)")
        
        // Append recipe cover images
        appendImage(recipeCoverPicture1, withName: "recipeCoverPicture1", fileName: "recipeCoverPicture1.jpg")
        appendImage(recipeCoverPicture2, withName: "recipeCoverPicture2", fileName: "recipeCoverPicture2.jpg")
        
        // Append instruction images
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
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIPutError.invalidResponse))
                return
            }
            
            completion(.success("Recipe updated successfully"))
        }.resume()
    }
}

enum APIPutError: Error {
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
