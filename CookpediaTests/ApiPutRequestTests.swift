//
//  ApiPutRequestTests.swift
//  CookpediaTests
//
//  Created by Bilal Dallali on 12/03/2025.
//

import XCTest
@testable import Cookpedia

final class ApiPutRequestTests: XCTestCase {

    var apiRequest: APIPutRequest!
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        
        apiRequest = APIPutRequest(networkService: mockSession)
    }
    
    override func tearDown() {
        apiRequest = nil
        mockSession = nil
        super.tearDown()
    }
    
    // Test Update User Profile Success (200 - Returns success message)
    func testUpdateUserProfileSuccess() async throws {
        let jsonData = "Profile updated successfully".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/edit-profile/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let user = EditUser(id: 1, fullName: "John Doe", username: "john_doe", description: "Food Blogger", youtube: nil, facebook: nil, twitter: nil, instagram: nil, website: nil, city: "New York", country: "USA", profilePictureUrl: nil)
        
        let message = try await apiRequest.updateUserProfile(userId: 1, user: user, profilePicture: nil)
        
        XCTAssertEqual(message, "Profile updated successfully", "Expected success message but got \(message)")
    }
    
    // Test Profile Update with Image
    func testUpdateUserProfileWithProfileImageSuccess() async throws {
        let jsonData = "Profile updated successfully".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/edit-profile/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let user = EditUser(id: 1, fullName: "John Doe", username: "john_doe", description: "Food Blogger", youtube: nil, facebook: nil, twitter: nil, instagram: nil, website: nil, city: "New York", country: "USA", profilePictureUrl: nil)
        
        // Create a dummy image for testing
        let testImage = UIImage(systemName: "person.circle")!
        
        let message = try await apiRequest.updateUserProfile(userId: 1, user: user, profilePicture: testImage)
        
        XCTAssertEqual(message, "Profile updated successfully", "Expected success message but got \(message)")
    }
    
    // Test Bad Request (400 - Throws `badRequest`)
    func testUpdateUserProfileBadRequest() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/edit-profile/1")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            let user = EditUser(id: 1, fullName: "John Doe", username: "john_doe", description: "Food Blogger", youtube: nil, facebook: nil, twitter: nil, instagram: nil, website: nil, city: "New York", country: "USA", profilePictureUrl: nil)
            _ = try await apiRequest.updateUserProfile(userId: 1, user: user, profilePicture: nil)
            XCTFail("Expected APIPutError.badRequest but got success")
        } catch let error as APIPutError {
            XCTAssertEqual(error, APIPutError.badRequest)
        }
    }
    
    // Test User Not Found (404 - Throws `userNotFound`)
    func testUpdateUserProfileNotFound() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/edit-profile/1")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            let user = EditUser(id: 1, fullName: "John Doe", username: "john_doe", description: "Food Blogger", youtube: nil, facebook: nil, twitter: nil, instagram: nil, website: nil, city: "New York", country: "USA", profilePictureUrl: nil)
            _ = try await apiRequest.updateUserProfile(userId: 1, user: user, profilePicture: nil)
            XCTFail("Expected APIPutError.userNotFound but got success")
        } catch let error as APIPutError {
            XCTAssertEqual(error, APIPutError.userNotFound)
        }
    }
    
    // Test Server Error (500 - Throws `serverError`)
    func testUpdateUserProfileServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/edit-profile/1")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            let user = EditUser(id: 1, fullName: "John Doe", username: "john_doe", description: "Food Blogger", youtube: nil, facebook: nil, twitter: nil, instagram: nil, website: nil, city: "New York", country: "USA", profilePictureUrl: nil)
            _ = try await apiRequest.updateUserProfile(userId: 1, user: user, profilePicture: nil)
            XCTFail("Expected APIPutError.serverError but got success")
        } catch let error as APIPutError {
            XCTAssertEqual(error, APIPutError.serverError)
        }
    }
    
    // Test Update Recipe Success (200 - Returns success message)
    func testUpdateRecipeSuccess() async throws {
        let jsonData = "Recipe updated successfully".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/update-recipe/10")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let updatedRecipe = RecipeRegistration(
            userId: 1,
            title: "Updated Recipe",
            recipeCoverPictureUrl1: nil,
            recipeCoverPictureUrl2: nil,
            description: "This is an updated recipe.",
            cookTime: "30 mins",
            serves: "4",
            origin: "Italy",
            ingredients: "Tomatoes, Basil, Cheese",
            instructions: "Mix and cook"
        )
        
        let message = try await apiRequest.updateRecipe(
            recipeId: 10,
            updatedRecipe: updatedRecipe,
            recipeCoverPicture1: nil,
            recipeCoverPicture2: nil,
            instructionImages: [],
            isPublished: true
        )
        
        XCTAssertEqual(message, "Recipe updated successfully", "Expected success message but got \(message)")
    }
    
    // Test Multipart Form-Data Contains Images
    func testUpdateRecipWithImageseSuccess() async throws {
        let jsonData = "Recipe updated successfully".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/update-recipe/10")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let updatedRecipe = RecipeRegistration(
            userId: 1,
            title: "Updated Recipe",
            recipeCoverPictureUrl1: nil,
            recipeCoverPictureUrl2: nil,
            description: "This is an updated recipe.",
            cookTime: "30 mins",
            serves: "4",
            origin: "Italy",
            ingredients: "Tomatoes, Basil, Cheese",
            instructions: "Mix and cook"
        )
        
        let testImage1 = UIImage(systemName: "photo")!
        let testImage2 = UIImage(systemName: "photo")!
        let instructionImages = [(testImage1, "step1.jpg"), (testImage2, "step2.jpg")]
        
        let message = try await apiRequest.updateRecipe(
            recipeId: 10,
            updatedRecipe: updatedRecipe,
            recipeCoverPicture1: testImage1,
            recipeCoverPicture2: testImage2,
            instructionImages: instructionImages,
            isPublished: true
        )
        
        XCTAssertEqual(message, "Recipe updated successfully", "Expected success message but got \(message)")
    }
    
    // Test Bad Request (400 - Throws `badRequest`)
    func testUpdateRecipeBadRequest() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/update-recipe/10")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let updatedRecipe = RecipeRegistration(
            userId: 1,
            title: "",
            recipeCoverPictureUrl1: nil,
            recipeCoverPictureUrl2: nil,
            description: "",
            cookTime: "",
            serves: "",
            origin: "",
            ingredients: "",
            instructions: ""
        )
        
        do {
            _ = try await apiRequest.updateRecipe(
                recipeId: 10,
                updatedRecipe: updatedRecipe,
                recipeCoverPicture1: nil,
                recipeCoverPicture2: nil,
                instructionImages: [],
                isPublished: true
            )
            XCTFail("Expected APIPutError.badRequest but got success")
        } catch let error as APIPutError {
            XCTAssertEqual(error, APIPutError.badRequest)
        }
    }
    
    // Test Recipe Not Found (404 - Throws `userNotFound`)
    func testUpdateRecipeNotFound() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/update-recipe/10")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        let updatedRecipe = RecipeRegistration(
            userId: 1,
            title: "Updated Recipe",
            recipeCoverPictureUrl1: nil,
            recipeCoverPictureUrl2: nil,
            description: "This is an updated recipe.",
            cookTime: "30 mins",
            serves: "4",
            origin: "Italy",
            ingredients: "Tomatoes, Basil, Cheese",
            instructions: "Mix and cook"
        )
        
        do {
            _ = try await apiRequest.updateRecipe(
                recipeId: 10,
                updatedRecipe: updatedRecipe,
                recipeCoverPicture1: nil,
                recipeCoverPicture2: nil,
                instructionImages: [],
                isPublished: true
            )
            XCTFail("Expected APIPutError.userNotFound but got success")
        } catch let error as APIPutError {
            XCTAssertEqual(error, APIPutError.userNotFound)
        }
    }
    
    // Test Server Error (500 - Throws `serverError`)
    func testUpdateRecipeServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/update-recipe/10")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        let updatedRecipe = RecipeRegistration(
            userId: 1,
            title: "Updated Recipe",
            recipeCoverPictureUrl1: nil,
            recipeCoverPictureUrl2: nil,
            description: "This is an updated recipe.",
            cookTime: "30 mins",
            serves: "4",
            origin: "Italy",
            ingredients: "Tomatoes, Basil, Cheese",
            instructions: "Mix and cook"
        )
        
        do {
            _ = try await apiRequest.updateRecipe(
                recipeId: 10,
                updatedRecipe: updatedRecipe,
                recipeCoverPicture1: nil,
                recipeCoverPicture2: nil,
                instructionImages: [],
                isPublished: true
            )
            XCTFail("Expected APIPutError.serverError but got success")
        } catch let error as APIPutError {
            XCTAssertEqual(error, APIPutError.serverError)
        }
    }
    
}
