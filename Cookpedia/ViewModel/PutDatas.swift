//
//  PutDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 23/12/2024.
//

import Foundation
import UIKit

class APIPutRequest: ObservableObject {
    
    private let networkService: NetworkService
    
    // Dependency Injection
    init(networkService: NetworkService = URLSession.shared) {
        self.networkService = networkService
    }
    
    func updateUserProfile(userId: Int, user: EditUser, profilePicture: UIImage?) async throws -> String {
        let endpoint = "/users/edit-profile/\(userId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPutError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // Define multipart boundary
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Function to append text fields
        func appendField(_ name: String, value: String?) {
            guard let value = value else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Function to append image data
        func appendImage(_ image: UIImage?, withName name: String) {
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(name).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Append user fields
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
        
        // Append profile picture if provided
        appendImage(profilePicture, withName: "profilePicture")
        
        // End the multipart body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // 🔥 Use injected `networkService` instead of `URLSession.shared`
        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIPutError.invalidResponse
        }
        
        // Handle response status codes
        switch httpResponse.statusCode {
        case 200:
            return "Profile updated successfully"
        case 400:
            throw APIPutError.badRequest
        case 404:
            throw APIPutError.userNotFound
        case 500:
            throw APIPutError.serverError
        default:
            throw APIPutError.invalidResponse
        }
    }
    
    func updateRecipe(recipeId: Int, updatedRecipe: RecipeRegistration, recipeCoverPicture1: UIImage?, recipeCoverPicture2: UIImage?, instructionImages: [(UIImage, String)], isPublished: Bool) async throws -> String {
        let endpoint = "/recipes/update-recipe/\(recipeId)"
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIPutError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Helper function to append text fields
        func appendField(_ name: String, value: String?) {
            guard let value = value else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Helper function to append image data
        func appendImage(_ image: UIImage?, withName name: String, fileName: String) {
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Append all fields and images
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
        
        // Append images
        appendImage(recipeCoverPicture1, withName: "recipeCoverPicture1", fileName: "recipeCoverPicture1.jpg")
        appendImage(recipeCoverPicture2, withName: "recipeCoverPicture2", fileName: "recipeCoverPicture2.jpg")
        
        // Append instruction images
        for (image, fileName) in instructionImages {
            appendImage(image, withName: "instructionImages", fileName: fileName)
        }
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // Execute the request asynchronously
        let (data, response) = try await networkService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIPutError.invalidResponse
        }
        
        // Check the response status code
        switch httpResponse.statusCode {
        case 200:
            return "Recipe updated successfully"
        case 400:
            throw APIPutError.badRequest
        case 404:
            throw APIPutError.userNotFound
        case 500:
            throw APIPutError.serverError
        default:
            throw APIPutError.invalidResponse
        }
    }
}

enum APIPutError: Error {
    case invalidUrl
    case invalidResponse
    case decodingError
    case badRequest
    case userNotFound
    case serverError
    
    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .decodingError:
            return "Decoding error"
        case .badRequest:
            return "Bad Request"
        case .userNotFound:
            return "User not found"
        case .serverError:
            return "Server error"
        }
    }
}
