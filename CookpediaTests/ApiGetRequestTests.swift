//
//  ApiGetRequestTests.swift
//  CookpediaTests
//
//  Created by Bilal Dallali on 12/03/2025.
//

import XCTest
@testable import Cookpedia

final class ApiGetRequestTests: XCTestCase {
    var apiRequest: APIGetRequest!
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        
        apiRequest = APIGetRequest(networkService: mockSession)
    }
    
    override func tearDown() {
        apiRequest = nil
        mockSession = nil
        super.tearDown()
    }
    
    // ✅ Test Get User Data Success (200)
    func testGetUserDataSuccess() async throws {
        let jsonData = """
            {
                "id": 1,
                "username": "testUser",
                "email": "test@example.com",
                "password": "hashedpassword",
                "fullName": "Test User",
                "phoneNumber": "123456789",
                "gender": "Male",
                "dateOfBirth": "2000-01-01",
                "profilePictureUrl": "http://example.com/profile.jpg",
                "country": "USA",
                "city": "New York",
                "cookingLevel": "Intermediate",
                "description": "I love cooking!",
                "youtube": "youtube.com/test",
                "facebook": "facebook.com/test",
                "twitter": "twitter.com/test",
                "instagram": "instagram.com/test",
                "website": "test.com",
                "createdAt": "2024-01-01"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/profile/1")!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        
        let user = try await apiRequest.getUserDataFromUserId(userId: 1)
        
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.username, "testUser")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.fullName, "Test User")
        XCTAssertEqual(user.city, "New York")
    }
    
    // Test Invalid Request (400)
    func testGetUserDataInvalidRequest() async throws {
        let jsonData = """
        {
            "error": "Invalid request"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/profile/1")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getUserDataFromUserId(userId: -1)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test User Not Found (404)
    func testGetUserDataInvalidResponse() async throws {
        let jsonData = """
        {
            "error": "Invalid response"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/profile/999")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getUserDataFromUserId(userId: 999)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // 🚨 Test Server Error (500)
    func testGetUserDataServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/profile/1")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getUserDataFromUserId(userId: 1)
            XCTFail("Expected APIGetError.serverError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // 🚨 Test Decoding Error (Invalid JSON Response)
    func testGetUserDataDecodingError() async throws {
        let invalidJsonData = """
        {
            "invalid_key": "missing_data"
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/profile/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getUserDataFromUserId(userId: 1)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
}
