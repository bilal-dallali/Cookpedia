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
    
    // 🚨 Test for Email Already Exists (400)
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
    
    // 🚨 Test for Username Already Exists (400)
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
    
    // 🚨 Test for Phone Number Already Exists (400)
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
    
    // 🚨 Test for Generic 400 Error (Invalid Data)
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
    
    // 🚨 Test for Server Error (500)
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
}
