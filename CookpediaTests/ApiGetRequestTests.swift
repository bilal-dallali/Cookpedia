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
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/profile/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
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
    
    // Test Server Error (500)
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
    
    // Test Decoding Error (Invalid JSON Response)
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
    
    // Test Fetch Recipes Success (200)
    func testGetRecipesFromUserIdSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 1,
                    "title": "Pasta Carbonara",
                    "recipeCoverPictureUrl1": "https://example.com/recipe1.jpg"
                },
                {
                    "id": 2,
                    "title": "Chicken Alfredo",
                    "recipeCoverPictureUrl1": "https://example.com/recipe2.jpg"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/fetch-all-recipes-from-user/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getRecipesFromUserId(userId: 1)
        
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes[0].id, 1)
        XCTAssertEqual(recipes[0].title, "Pasta Carbonara")
        XCTAssertEqual(recipes[0].recipeCoverPictureUrl1, "https://example.com/recipe1.jpg")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetRecipesFromUserIdInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/fetch-all-recipes-from-user/1")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getRecipesFromUserId(userId: 1)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetRecipesFromUserIdDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/fetch-all-recipes-from-user/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getRecipesFromUserId(userId: 1)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Bookmark Exists (User has bookmarked the recipe)
    func testGetBookmarkExists() async throws {
        let jsonData = """
            [
                {
                    "userId": 1,
                    "recipeId": 101
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmark/1/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let isBookmarked = try await apiRequest.getBookmark(userId: 1, recipeId: 101)
        
        XCTAssertTrue(isBookmarked, "Expected recipe to be bookmarked but got false")
    }
    
    // Test Bookmark Does Not Exist (User has not bookmarked the recipe)
    func testGetBookmarkNotExists() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmark/1/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let isBookmarked = try await apiRequest.getBookmark(userId: 1, recipeId: 101)
        
        XCTAssertFalse(isBookmarked, "Expected recipe to not be bookmarked but got true")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetBookmarkInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmark/1/101")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getBookmark(userId: 1, recipeId: 101)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetBookmarkDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmark/1/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getBookmark(userId: 1, recipeId: 101)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Published Recipes Success (200)
    func testGetPublishedRecipesFromUserIdSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 1,
                    "title": "Pasta Carbonara",
                    "recipeCoverPictureUrl1": "https://example.com/recipe1.jpg"
                },
                {
                    "id": 2,
                    "title": "Chicken Alfredo",
                    "recipeCoverPictureUrl1": "https://example.com/recipe2.jpg"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/fetch-user-published-recipes/1/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getPublishedRecipesFromUserId(userId: 1, published: true)
        
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes[0].id, 1)
        XCTAssertEqual(recipes[0].title, "Pasta Carbonara")
        XCTAssertEqual(recipes[0].recipeCoverPictureUrl1, "https://example.com/recipe1.jpg")
    }
    
    // Test No Published Recipes (200 - Empty Array)
    func testGetPublishedRecipesFromUserIdEmpty() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/fetch-user-published-recipes/1/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getPublishedRecipesFromUserId(userId: 1, published: true)
        
        XCTAssertEqual(recipes.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetPublishedRecipesFromUserIdInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/fetch-user-published-recipes/1/1")!,statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getPublishedRecipesFromUserId(userId: 1, published: true)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetPublishedRecipesFromUserIdDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/fetch-user-published-recipes/1/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getPublishedRecipesFromUserId(userId: 1, published: true)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Published Recipes Count Success (200)
    func testGetPublishedRecipesCountSuccess() async throws {
        let jsonData = """
            {
                "count": 5
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/published-recipes-count/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let count = try await apiRequest.getPublishedRecipesCount(userId: 1)
        
        XCTAssertEqual(count, 5, "Expected count to be 5 but got \(count)")
    }
    
    // Test No Published Recipes (200 - Zero Count)
    func testGetPublishedRecipesCountZero() async throws {
        let jsonData = """
            {
                "count": 0
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/published-recipes-count/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let count = try await apiRequest.getPublishedRecipesCount(userId: 1)
        
        XCTAssertEqual(count, 0, "Expected count to be 0 but got \(count)")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetPublishedRecipesCountInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/published-recipes-count/1")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getPublishedRecipesCount(userId: 1)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetPublishedRecipesCountDecodingError() async throws {
        let invalidJsonData = """
            {
                "invalid_field": "This is an invalid response"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/published-recipes-count/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getPublishedRecipesCount(userId: 1)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Draft Recipes Count Success (200)
    func testGetDraftRecipesCountSuccess() async throws {
        let jsonData = """
            {
                "count": 3
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/draft-recipes-count/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let count = try await apiRequest.getDraftRecipesCount(userId: 1)
        
        XCTAssertEqual(count, 3, "Expected count to be 3 but got \(count)")
    }
    
    // Test No Draft Recipes (200 - Zero Count)
    func testGetDraftRecipesCountZero() async throws {
        let jsonData = """
            {
                "count": 0
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/draft-recipes-count/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let count = try await apiRequest.getDraftRecipesCount(userId: 1)
        
        XCTAssertEqual(count, 0, "Expected count to be 0 but got \(count)")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetDraftRecipesCountInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/draft-recipes-count/1")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getDraftRecipesCount(userId: 1)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetDraftRecipesCountDecodingError() async throws {
        let invalidJsonData = """
            {
                "invalid_field": "This is an invalid response"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/draft-recipes-count/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getDraftRecipesCount(userId: 1)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
}
