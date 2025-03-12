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
    
}
