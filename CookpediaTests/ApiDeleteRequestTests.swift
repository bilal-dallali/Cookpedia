//
//  ApiDeleteRequestTests.swift
//  CookpediaTests
//
//  Created by Bilal Dallali on 12/03/2025.
//

import XCTest
@testable import Cookpedia

final class ApiDeleteRequestTests: XCTestCase {
    
    var apiRequest: APIDeleteRequest!
    var mockSession: URLSession!

    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        
        apiRequest = APIDeleteRequest(networkService: mockSession)
    }
    
    override func tearDown() {
        apiRequest = nil
        mockSession = nil
        super.tearDown()
    }
    
    // Test Unfollow Success (200 - Returns success message)
    func testUnfollowUserSuccess() async throws {
        let jsonData = """
            {
                "message": "User successfully unfollowed"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/unfollow/1/2")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let message = try await apiRequest.unfollowUser(followerId: 1, followedId: 2)
        
        XCTAssertEqual(message, "User successfully unfollowed", "Expected success message but got \(message)")
    }
    
    // Test Backend Error Message (400 - Returns error message)
    func testUnfollowUserBackendError() async throws {
        let jsonData = """
            {
                "error": "Cannot unfollow this user"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/unfollow/1/2")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.unfollowUser(followerId: 1, followedId: 2)
            XCTFail("Expected NSError with error message but got success")
        } catch let error as NSError {
            XCTAssertEqual(error.localizedDescription, "Cannot unfollow this user")
        }
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testUnfollowUserInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/unfollow/1/2")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.unfollowUser(followerId: 1, followedId: 2)
            XCTFail("Expected APIDeleteError.invalidResponse but got success")
        } catch let error as APIDeleteError {
            XCTAssertEqual(error, APIDeleteError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testUnfollowUserDecodingError() async throws {
        let invalidJsonData = """
            {
                "unknown_key": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/unfollow/1/2")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.unfollowUser(followerId: 1, followedId: 2)
            XCTFail("Expected APIDeleteError.decodingError but got success")
        } catch let error as APIDeleteError {
            XCTAssertEqual(error, APIDeleteError.decodingError)
        }
    }
    
    // Test Delete Recipe Success (200 - Returns success message)
    func testDeleteRecipeSuccess() async throws {
        let jsonData = "Recipe deleted successfully".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/delete-recipe/10")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let message = try await apiRequest.deleteRecipe(recipeId: 10)
        
        XCTAssertEqual(message, "Recipe deleted successfully", "Expected success message but got \(message)")
    }
    
    // Test Recipe Not Found (404 - Throws `userNotFound`)
    func testDeleteRecipeNotFound() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/delete-recipe/10")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.deleteRecipe(recipeId: 10)
            XCTFail("Expected APIDeleteError.userNotFound but got success")
        } catch let error as APIDeleteError {
            XCTAssertEqual(error, APIDeleteError.userNotFound)
        }
    }
    
    // Test Server Error (500 - Throws `serverError`)
    func testDeleteRecipeServerError() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/delete-recipe/10")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.deleteRecipe(recipeId: 10)
            XCTFail("Expected APIDeleteError.serverError but got success")
        } catch let error as APIDeleteError {
            XCTAssertEqual(error, APIDeleteError.serverError)
        }
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testDeleteRecipeInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/delete-recipe/10")!, statusCode: 403, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.deleteRecipe(recipeId: 10)
            XCTFail("Expected APIDeleteError.invalidResponse but got success")
        } catch let error as APIDeleteError {
            XCTAssertEqual(error, APIDeleteError.invalidResponse)
        }
    }
    
    
}
