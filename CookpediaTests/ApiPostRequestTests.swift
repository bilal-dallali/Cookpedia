//
//  CookpediaTests.swift
//  CookpediaTests
//
//  Created by Bilal Dallali on 10/03/2025.
//

import XCTest
@testable import Cookpedia

final class APIPostRequestTests: XCTestCase {
    
    var apiRequest: APIPostRequest!
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        
        apiRequest = APIPostRequest(networkService: mockSession)
    }
    
    override func tearDown() {
        apiRequest = nil
        mockSession = nil
        super.tearDown()
    }
    
    // Register User Success (201)
    func testRegisterUserSuccess() async throws {
        let jsonData = """
        {
            "token": "testToken123",
            "userId": 1
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/registration")!, statusCode: 201, httpVersion: nil, headerFields: nil)
        
        let user = UserRegistration(username: "testUser", email: "test@example.com", password: "password", country: "USA", level: "Beginner", fullName: "Test User", phoneNumber: "1234567890", gender: "Male", date: "2024-01-01", city: "NY", profilePictureUrl: "")
        
        let result = try await apiRequest.registerUser(registration: user, profilePicture: nil, rememberMe: true)
        
        XCTAssertEqual(result.token, "testToken123")
        XCTAssertEqual(result.id, 1)
    }
    
    // Upload profile picture register user (201)
    func testRegisterUserWithProfilePicture() async throws {
        let jsonData = """
        {
            "token": "testTokenWithImage",
            "userId": 2
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/registration")!, statusCode: 201, httpVersion: nil, headerFields: nil)
        
        let user = UserRegistration(username: "imageUser", email: "image@example.com", password: "password123", country: "France", level: "Intermediate", fullName: "Image User", phoneNumber: "9876543210", gender: "Female", date: "2024-02-02", city: "Paris", profilePictureUrl: "")
        
        // Create a dummy image for testing
        let testImage = UIImage(systemName: "person.circle")!
        
        let result = try await apiRequest.registerUser(registration: user, profilePicture: testImage, rememberMe: false)
        
        XCTAssertEqual(result.token, "testTokenWithImage")
        XCTAssertEqual(result.id, 2)
    }
    
    // Test for Email Already Exists (400)
    func testRegisterUserEmailAlreadyExists() async throws {
        let jsonData = """
        {
            "error": "Email already exists"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/registration")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let user = UserRegistration(username: "testUser", email: "existing@example.com", password: "password", country: "USA", level: "Beginner", fullName: "Existing User", phoneNumber: "1234567890", gender: "Male", date: "2024-01-01", city: "NY", profilePictureUrl: "")
        
        do {
            _ = try await apiRequest.registerUser(registration: user, profilePicture: nil, rememberMe: false)
            XCTFail("Expected APIPostError.emailAlreadyExists but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.emailAlreadyExists)
        }
    }
    
    // Test for Username Already Exists (400)
    func testRegisterUserUsernameAlreadyExists() async throws {
        let jsonData = """
        {
            "error": "Username already exists"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/registration")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let user = UserRegistration(username: "existingUsername", email: "user@example.com", password: "password", country: "USA", level: "Beginner", fullName: "Existing User", phoneNumber: "1234567890", gender: "Male", date: "2024-01-01", city: "NY", profilePictureUrl: "")
        
        do {
            _ = try await apiRequest.registerUser(registration: user, profilePicture: nil, rememberMe: false)
            XCTFail("Expected APIPostError.usernameAlreadyExists but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.usernameAlreadyExists)
        }
    }
    
    // Test for Phone Number Already Exists (400)
    func testRegisterUserPhoneNumberAlreadyExists() async throws {
        let jsonData = """
        {
            "error": "Phone number already exists"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/registration")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let user = UserRegistration(username: "newUser", email: "new@example.com", password: "password", country: "USA", level: "Beginner", fullName: "New User", phoneNumber: "existingPhoneNumber", gender: "Male", date: "2024-01-01", city: "NY", profilePictureUrl: "")
        
        do {
            _ = try await apiRequest.registerUser(registration: user, profilePicture: nil, rememberMe: false)
            XCTFail("Expected APIPostError.phoneNumberAlreadyExists but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.phoneNumberAlreadyExists)
        }
    }
    
    // Test for Generic 400 Error (Invalid Data)
    func testRegisterUserInvalidData() async throws {
        let jsonData = """
        {
            "error": "Some other invalid data"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/registration")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let user = UserRegistration(username: "newUser", email: "new@example.com", password: "password", country: "USA", level: "Beginner", fullName: "New User", phoneNumber: "1234567890", gender: "Male", date: "2024-01-01", city: "NY", profilePictureUrl: "")
        
        do {
            _ = try await apiRequest.registerUser(registration: user, profilePicture: nil, rememberMe: false)
            XCTFail("Expected APIPostError.invalidData but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidData)
        }
    }
    
    // Test for Server Error (500)
    func testRegisterUserServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/registration")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        let user = UserRegistration(username: "serverErrorUser", email: "server@example.com", password: "password", country: "USA", level: "Beginner", fullName: "Server Error User", phoneNumber: "1234567890", gender: "Male", date: "2024-01-01", city: "NY", profilePictureUrl: "")
        
        do {
            _ = try await apiRequest.registerUser(registration: user, profilePicture: nil, rememberMe: false)
            XCTFail("Expected APIPostError.serverError but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.serverError)
        }
    }
    
    // Test Successful Login (200)
    func testLoginUserSuccess() async throws {
        let jsonData = """
        {
            "token": "validToken123",
            "id": 1
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/login")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let result = try await apiRequest.loginUser(email: "test@example.com", password: "password123", rememberMe: true)
        
        XCTAssertEqual(result.token, "validToken123")
        XCTAssertEqual(result.id, 1)
    }
    
    // Test Invalid Credentials (401)
    func testLoginUserInvalidCredentials() async throws {
        let jsonData = """
        {
            "error": "Invalid credentials"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/login")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.loginUser(email: "wrong@example.com", password: "wrongpassword", rememberMe: false)
            XCTFail("Expected APIPostError.invalidCredentials but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidCredentials)
        }
    }
    
    // Test User Not Found (404)
    func testLoginUserNotFound() async throws {
        let jsonData = """
        {
            "error": "User not found"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/login")!,statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.loginUser(email: "nonexistent@example.com", password: "password123", rememberMe: false)
            XCTFail("Expected APIPostError.userNotFound but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.userNotFound)
        }
    }
    
    // Test Server Error (500)
    func testLoginUserServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/login")!,statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.loginUser(email: "servererror@example.com", password: "password", rememberMe: false)
            XCTFail("Expected APIPostError.serverError but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.serverError)
        }
    }
    
    // Test Successful Reset Code Request (200)
    func testSendResetCodeSuccess() async throws {
        MockURLProtocol.mockResponseData = nil // No response body needed
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/send-reset-code")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.sendResetCode(email: "test@example.com")
        } catch {
            XCTFail("Expected success, but got \(error)")
        }
    }
    
    // Test User Not Found (404)
    func testSendResetCodeUserNotFound() async throws {
        let jsonData = """
        {
            "error": "User not found"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/send-reset-code")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.sendResetCode(email: "nonexistent@example.com")
            XCTFail("Expected APIPostError.userNotFound but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.userNotFound)
        }
    }
    
    // Test Server Error (500)
    func testSendResetCodeServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/send-reset-code")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.sendResetCode(email: "servererror@example.com")
            XCTFail("Expected APIPostError.serverError but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.serverError)
        }
    }
    
    // Test Successful Reset Code Verification (200)
    func testVerifyResetCodeSuccess() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/verify-reset-code")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.verifyResetCode(email: "test@example.com", code: "123456")
        } catch {
            XCTFail("Expected success, but got \(error)")
        }
    }
    
    // Test Invalid Reset Code (400)
    func testVerifyResetCodeInvalidCode() async throws {
        let jsonData = """
        {
            "error": "Invalid reset code"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/verify-reset-code")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.verifyResetCode(email: "test@example.com", code: "wrongcode")
            XCTFail("Expected APIPostError.invalidData but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidData)
        }
    }
    
    // Test User Not Found (404)
    func testVerifyResetCodeUserNotFound() async throws {
        let jsonData = """
        {
            "error": "User not found"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/verify-reset-code")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.verifyResetCode(email: "nonexistent@example.com", code: "123456")
            XCTFail("Expected APIPostError.userNotFound but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.userNotFound)
        }
    }
    
    // Test Server Error (500)
    func testVerifyResetCodeServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/verify-reset-code")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.verifyResetCode(email: "servererror@example.com", code: "123456")
            XCTFail("Expected APIPostError.serverError but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.serverError)
        }
    }
    
    // Test Successful Password Reset (200)
    func testResetPasswordSuccess() async throws {
        let jsonData = """
        {
            "token": "newToken123",
            "id": 1
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/reset-password")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let result = try await apiRequest.resetPassword(email: "test@example.com", newPassword: "newStrongPass", resetCode: "123456", rememberMe: true)
        
        XCTAssertEqual(result.token, "newToken123")
        XCTAssertEqual(result.id, 1)
    }
    
    // Test Invalid Reset Code (400)
    func testResetPasswordInvalidCode() async throws {
        let jsonData = """
        {
            "error": "Invalid reset code"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/reset-password")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.resetPassword(email: "test@example.com", newPassword: "newStrongPass", resetCode: "wrongcode", rememberMe: false)
            XCTFail("Expected APIPostError.invalidCredentials but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidCredentials)
        }
    }
    
    // Test Server Error (500)
    func testResetPasswordServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/reset-password")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.resetPassword(email: "servererror@example.com", newPassword: "newStrongPass", resetCode: "123456", rememberMe: false)
            XCTFail("Expected APIPostError.serverError but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.serverError)
        }
    }
    
    // Test Successful Recipe Upload (201)
    func testUploadRecipeSuccess() async throws {
        let jsonData = """
        {
            "message": "Recipe uploaded successfully"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/upload")!, statusCode: 201, httpVersion: nil, headerFields: nil)
        
        let recipe = RecipeRegistration(
            userId: 1,
            title: "Test Recipe",
            recipeCoverPictureUrl1: nil,
            recipeCoverPictureUrl2: nil,
            description: "Delicious test recipe",
            cookTime: "30 minutes",
            serves: "4",
            origin: "Italy",
            ingredients: "Tomatoes, Basil, Garlic",
            instructions: "Mix ingredients and cook"
        )
        
        let testImage1 = UIImage(systemName: "photo")!
        let testImage2 = UIImage(systemName: "photo")!
        let instructionImages = [(testImage1, "step1.jpg"), (testImage2, "step2.jpg")]
        
        let result = try await apiRequest.uploadRecipe(recipe: recipe, recipeCoverPicture1: testImage1, recipeCoverPicture2: testImage2, instructionImages: instructionImages, isPublished: true)
        
        XCTAssertEqual(result, "Recipe uploaded successfully")
    }
    
    // Test Invalid Request (400)
    func testUploadRecipeInvalidRequest() async throws {
        let jsonData = """
        {
            "error": "Invalid request"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/upload")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let recipe = RecipeRegistration(
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
        
        let testImage1 = UIImage(systemName: "photo")!
        let testImage2 = UIImage(systemName: "photo")!
        let instructionImages = [(testImage1, "step1.jpg"), (testImage2, "step2.jpg")]
        
        do {
            _ = try await apiRequest.uploadRecipe(recipe: recipe, recipeCoverPicture1: testImage1, recipeCoverPicture2: testImage2, instructionImages: instructionImages, isPublished: false)
            XCTFail("Expected NSError with code 400 but got success")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 400)
        }
    }
    
    // Test Server Error (500)
    func testUploadRecipeServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/upload")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        let recipe = RecipeRegistration(
            userId: 1,
            title: "Test Recipe",
            recipeCoverPictureUrl1: nil,
            recipeCoverPictureUrl2: nil,
            description: "Delicious test recipe",
            cookTime: "30 minutes",
            serves: "4",
            origin: "Italy",
            ingredients: "Tomatoes, Basil, Garlic",
            instructions: "Mix ingredients and cook"
        )
        
        let testImage1 = UIImage(systemName: "photo")!
        let testImage2 = UIImage(systemName: "photo")!
        let instructionImages = [(testImage1, "step1.jpg"), (testImage2, "step2.jpg")]
        
        do {
            _ = try await apiRequest.uploadRecipe(recipe: recipe, recipeCoverPicture1: testImage1, recipeCoverPicture2: testImage2, instructionImages: instructionImages, isPublished: true)
            XCTFail("Expected NSError with code 500 but got success")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 500)
        }
    }
    
    // Test Bookmark Added (201)
    func testToggleBookmarkAdded() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmark")!, statusCode: 201, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.toggleBookmark(userId: 1, recipeId: 101, isBookmarked: false)
        } catch {
            XCTFail("Expected success, but got \(error)")
        }
    }
    
    // Test Bookmark Removed (200)
    func testToggleBookmarkRemoved() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmark")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.toggleBookmark(userId: 1, recipeId: 101, isBookmarked: true)
        } catch {
            XCTFail("Expected success, but got \(error)")
        }
    }
    
    // Test Invalid Request (400)
    func testToggleBookmarkInvalidRequest() async throws {
        let jsonData = """
        {
            "error": "Invalid request"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmark")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.toggleBookmark(userId: 0, recipeId: 0, isBookmarked: false)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidResponse)
        }
    }
    
    // Test Server Error (500)
    func testToggleBookmarkServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmark")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.toggleBookmark(userId: 1, recipeId: 101, isBookmarked: false)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidResponse)
        }
    }
    
    // Test Follow User Success (201)
    func testFollowUserSuccess() async throws {
        let jsonData = """
        {
            "message": "Successfully followed user"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/follow")!, statusCode: 201, httpVersion: nil, headerFields: nil)
        
        let result = try await apiRequest.followUser(followerId: 1, followedId: 2)
        
        XCTAssertEqual(result, "Successfully followed user")
    }
    
    // Test Invalid Request (400)
    func testFollowUserInvalidRequest() async throws {
        let jsonData = """
        {
            "error": "Invalid request"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/follow")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.followUser(followerId: -1, followedId: -1)
            XCTFail("Expected APIPostError.invalidData but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidData)
        }
    }
    
    // Test User Not Found (404)
    func testFollowUserNotFound() async throws {
        let jsonData = """
        {
            "error": "User not found"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/follow")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.followUser(followerId: 999, followedId: 1000)
            XCTFail("Expected APIPostError.userNotFound but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.userNotFound)
        }
    }
    
    // Test Server Error (500)
    func testFollowUserServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/follow")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.followUser(followerId: 1, followedId: 2)
            XCTFail("Expected APIPostError.serverError but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.serverError)
        }
    }
    
    // Test Increment Views Success (200)
    func testIncrementViewsSuccess() async throws {
        let responseMessage = "View count updated successfully"
        let jsonData = responseMessage.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/increment-views/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let result = try await apiRequest.incrementViews(recipeId: 1)
        
        XCTAssertEqual(result, "View count updated successfully")
    }
    
    // Test Invalid Request (400)
    func testIncrementViewsInvalidRequest() async throws {
        let jsonData = """
        {
            "error": "Invalid request"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/increment-views/1")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.incrementViews(recipeId: -1)
            XCTFail("Expected APIPostError.invalidData but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidData)
        }
    }
    
    // Test Recipe Not Found (404)
    func testIncrementViewsRecipeNotFound() async throws {
        let jsonData = """
        {
            "error": "Recipe not found"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/increment-views/999")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.incrementViews(recipeId: 999)
            XCTFail("Expected APIPostError.userNotFound but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.userNotFound)
        }
    }
    
    // Test Server Error (500)
    func testIncrementViewsServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/increment-views/1")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.incrementViews(recipeId: 1)
            XCTFail("Expected APIPostError.serverError but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.serverError)
        }
    }
    
    // Test Post Comment Success (201)
    func testPostCommentSuccess() async throws {
        let responseMessage = "Comment posted successfully"
        let jsonData = responseMessage.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/add-comment")!, statusCode: 201, httpVersion: nil, headerFields: nil)
        
        let comment = CommentsPost(userId: 1, recipeId: 101, comment: "Great recipe!")
        
        let result = try await apiRequest.postComment(comment: comment)
        
        XCTAssertEqual(result, "Comment posted successfully")
    }
    
    // Test Invalid Request (400)
    func testPostCommentInvalidRequest() async throws {
        let jsonData = """
        {
            "error": "Invalid request"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/add-comment")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let comment = CommentsPost(userId: 0, recipeId: 0, comment: "")
        
        do {
            _ = try await apiRequest.postComment(comment: comment)
            XCTFail("Expected APIPostError.invalidData but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidData)
        }
    }
    
    // Test User Not Found (404)
    func testPostCommentUserNotFound() async throws {
        let jsonData = """
        {
            "error": "User not found"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/add-comment")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        let comment = CommentsPost(userId: 999, recipeId: 101, comment: "Great recipe!")
        
        do {
            _ = try await apiRequest.postComment(comment: comment)
            XCTFail("Expected APIPostError.userNotFound but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.userNotFound)
        }
    }
    
    // Test Server Error (500)
    func testPostCommentServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/add-comment")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        let comment = CommentsPost(userId: 1, recipeId: 101, comment: "Great recipe!")
        
        do {
            _ = try await apiRequest.postComment(comment: comment)
            XCTFail("Expected APIPostError.serverError but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.serverError)
        }
    }
    
    // Test Like Comment Success (200)
    func testLikeCommentSuccess() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/like-comment")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.likeComment(userId: 1, commentId: 101)
        } catch {
            XCTFail("Expected success, but got \(error)")
        }
    }
    
    // Test Invalid Request (400)
    func testLikeCommentInvalidRequest() async throws {
        let jsonData = """
        {
            "error": "Invalid request"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/like-comment")!, statusCode: 400, httpVersion: nil,  headerFields: nil)
        
        do {
            try await apiRequest.likeComment(userId: -1, commentId: -1)
            XCTFail("Expected APIPostError.invalidData but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidData)
        }
    }
    
    // Test User or Comment Not Found (404)
    func testLikeCommentUserNotFound() async throws {
        let jsonData = """
        {
            "error": "User or comment not found"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/like-comment")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.likeComment(userId: 999, commentId: 1000)
            XCTFail("Expected APIPostError.userNotFound but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.userNotFound)
        }
    }
    
    // Test Server Error (500)
    func testLikeCommentServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/like-comment")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            try await apiRequest.likeComment(userId: 1, commentId: 101)
            XCTFail("Expected APIPostError.serverError but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.serverError)
        }
    }
    
    
    // Test Increment Recipe Search Success (200 - Returns success message)
    func testIncrementRecipeSearchSuccess() async throws {
        let jsonData = "Recipe search count incremented successfully".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/increment-searches/10")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let message = try await apiRequest.incrementRecipeSearch(recipeId: 10)
        
        XCTAssertEqual(message, "Recipe search count incremented successfully", "Expected success message but got \(message)")
    }
    
    // Test Invalid Data (400 - Throws `invalidData`)
    func testIncrementRecipeSearchInvalidData() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/increment-searches/10")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.incrementRecipeSearch(recipeId: 10)
            XCTFail("Expected APIPostError.invalidData but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidData)
        }
    }
    
    // Test Recipe Not Found (404 - Throws `userNotFound`)
    func testIncrementRecipeSearchNotFound() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/increment-searches/10")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.incrementRecipeSearch(recipeId: 10)
            XCTFail("Expected APIPostError.userNotFound but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.userNotFound)
        }
    }
    
    // Test Server Error (500 - Throws `serverError`)
    func testIncrementRecipeSearchServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/increment-searches/10")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.incrementRecipeSearch(recipeId: 10)
            XCTFail("Expected APIPostError.serverError but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.serverError)
        }
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testIncrementRecipeSearchInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/increment-searches/10")!, statusCode: 403, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.incrementRecipeSearch(recipeId: 10)
            XCTFail("Expected APIPostError.invalidResponse but got success")
        } catch let error as APIPostError {
            XCTAssertEqual(error, APIPostError.invalidResponse)
        }
    }
}
