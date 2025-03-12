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
    
    // ✅ Test Profile Update with Image
//    func testUpdateUserProfileWithImage() async throws {
//        let jsonData = "Profile updated successfully".data(using: .utf8)
//
//        MockURLProtocol.mockResponseData = jsonData
//        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/edit-profile/1")!,
//                                                       statusCode: 200,
//                                                       httpVersion: nil,
//                                                       headerFields: nil)
//
//        // Create a dummy image
//        let testImage = UIImage(systemName: "person.fill")!
//
//        let user = EditUser(id: 1, fullName: "John Doe", username: "john_doe", description: "Updated profile",
//                            youtube: nil, facebook: nil, twitter: nil, instagram: nil, website: nil,
//                            city: "New York", country: "USA", profilePictureUrl: nil)
//
//        let message = try await apiRequest.updateUserProfile(userId: 1, user: user, profilePicture: testImage)
//
//        XCTAssertEqual(message, "Profile updated successfully", "Expected success message but got \(message)")
//        
//        // ✅ Validate the request was sent with multipart form-data
//        guard let request = MockURLProtocol.lastRequest else {
//            XCTFail("Expected request but got nil")
//            return
//        }
//
//        XCTAssertEqual(request.httpMethod, "PUT", "Expected HTTP method PUT but got \(String(describing: request.httpMethod))")
//        XCTAssertTrue(request.value(forHTTPHeaderField: "Content-Type")?.contains("multipart/form-data") ?? false,
//                      "Expected multipart/form-data Content-Type but got \(String(describing: request.value(forHTTPHeaderField: "Content-Type")))")
//        
//        // ✅ Debugging: Print the request body
//        if let requestBody = MockURLProtocol.lastRequestBody {
//            print("Captured Request Body:\n", String(data: requestBody, encoding: .utf8) ?? "Invalid Body")
//        } else {
//            XCTFail("Request body is nil or could not be captured")
//        }
//
//        // ✅ Validate the request body contains profile picture data
//        guard let requestBody = MockURLProtocol.lastRequestBody else {
//            XCTFail("Expected request body but got nil")
//            return
//        }
//
//        let requestString = String(data: requestBody, encoding: .utf8)
//        
//        XCTAssertNotNil(requestString, "Failed to convert request body to string")
//        XCTAssertTrue(requestString!.contains("Content-Disposition: form-data; name=\"profilePicture\""),
//                      "Profile picture field not found in request")
//    }
    
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
