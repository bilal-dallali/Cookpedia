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
    
    // Test Fetch Saved Recipes Success (200)
    func testGetSavedRecipesSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 1,
                    "userId": 2,
                    "title": "Spaghetti Bolognese",
                    "recipeCoverPictureUrl1": "https://example.com/recipe1.jpg",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile.jpg"
                },
                {
                    "id": 2,
                    "userId": 3,
                    "title": "Chicken Teriyaki",
                    "recipeCoverPictureUrl1": "https://example.com/recipe2.jpg",
                    "fullName": "Jane Smith",
                    "profilePictureUrl": "https://example.com/profile2.jpg"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmarked-recipes/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getSavedRecipes(userId: 1)
        
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes[0].id, 1)
        XCTAssertEqual(recipes[0].title, "Spaghetti Bolognese")
        XCTAssertEqual(recipes[0].recipeCoverPictureUrl1, "https://example.com/recipe1.jpg")
        XCTAssertEqual(recipes[0].fullName, "John Doe")
        XCTAssertEqual(recipes[0].profilePictureUrl, "https://example.com/profile.jpg")
    }
    
    // Test No Saved Recipes (200 - Empty Array)
    func testGetSavedRecipesEmpty() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmarked-recipes/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getSavedRecipes(userId: 1)
        
        XCTAssertEqual(recipes.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetSavedRecipesInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmarked-recipes/1")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getSavedRecipes(userId: 1)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetSavedRecipesDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/bookmarked-recipes/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getSavedRecipes(userId: 1)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Recent Recipes Success (200)
    func testGetAllRecentRecipesSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 1,
                    "userId": 2,
                    "title": "Spaghetti Bolognese",
                    "recipeCoverPictureUrl1": "https://example.com/recipe1.jpg",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile.jpg"
                },
                {
                    "id": 2,
                    "userId": 3,
                    "title": "Chicken Teriyaki",
                    "recipeCoverPictureUrl1": "https://example.com/recipe2.jpg",
                    "fullName": "Jane Smith",
                    "profilePictureUrl": "https://example.com/profile2.jpg"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/recent-recipes")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getAllRecentRecipes()
        
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes[0].id, 1)
        XCTAssertEqual(recipes[0].title, "Spaghetti Bolognese")
        XCTAssertEqual(recipes[0].recipeCoverPictureUrl1, "https://example.com/recipe1.jpg")
        XCTAssertEqual(recipes[0].fullName, "John Doe")
        XCTAssertEqual(recipes[0].profilePictureUrl, "https://example.com/profile.jpg")
    }
    
    // Test No Recent Recipes (200 - Empty Array)
    func testGetAllRecentRecipesEmpty() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/recent-recipes")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getAllRecentRecipes()
        
        XCTAssertEqual(recipes.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetAllRecentRecipesInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/recent-recipes")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getAllRecentRecipes()
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetAllRecentRecipesDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/recent-recipes")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getAllRecentRecipes()
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Connected User Recipes with Details Success (200)
    func testGetConnectedUserRecipesWithDetailsSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 1,
                    "userId": 2,
                    "title": "Homemade Pizza",
                    "recipeCoverPictureUrl1": "https://example.com/recipe1.jpg",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile.jpg"
                },
                {
                    "id": 2,
                    "userId": 2,
                    "title": "Chocolate Cake",
                    "recipeCoverPictureUrl1": "https://example.com/recipe2.jpg",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile.jpg"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/user-recipes-with-details/2")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getConnectedUserRecipesWithDetails(userId: 2)
        
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes[0].id, 1)
        XCTAssertEqual(recipes[0].title, "Homemade Pizza")
        XCTAssertEqual(recipes[0].recipeCoverPictureUrl1, "https://example.com/recipe1.jpg")
        XCTAssertEqual(recipes[0].fullName, "John Doe")
        XCTAssertEqual(recipes[0].profilePictureUrl, "https://example.com/profile.jpg")
    }
    
    // Test No User Recipes (200 - Empty Array)
    func testGetConnectedUserRecipesWithDetailsEmpty() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/user-recipes-with-details/2")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getConnectedUserRecipesWithDetails(userId: 2)
        
        XCTAssertEqual(recipes.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetConnectedUserRecipesWithDetailsInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/user-recipes-with-details/2")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getConnectedUserRecipesWithDetails(userId: 2)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetConnectedUserRecipesWithDetailsDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/user-recipes-with-details/2")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getConnectedUserRecipesWithDetails(userId: 2)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Recipe Details Success (200)
    func testGetRecipeDetailsSuccess() async throws {
        let jsonData = """
            {
                "id": 1,
                "userId": 2,
                "title": "Homemade Pizza",
                "recipeCoverPictureUrl1": "https://example.com/recipe1.jpg",
                "recipeCoverPictureUrl2": "https://example.com/recipe2.jpg",
                "description": "Delicious homemade pizza recipe",
                "cookTime": "30 mins",
                "serves": "4",
                "origin": "Italy",
                "ingredients": [
                    {"index": 1, "ingredient": "Flour"},
                    {"index": 2, "ingredient": "Tomato Sauce"},
                    {"index": 3, "ingredient": "Cheese"}
                ],
                "instructions": [
                    {
                        "index": 1,
                        "instruction": "Preheat the oven to 220°C",
                        "instructionPictureUrl1": "https://example.com/instruction1.jpg",
                        "instructionPictureUrl2": null,
                        "instructionPictureUrl3": null
                    },
                    {
                        "index": 2,
                        "instruction": "Spread the sauce over the dough",
                        "instructionPictureUrl1": "https://example.com/instruction2.jpg",
                        "instructionPictureUrl2": "https://example.com/instruction3.jpg",
                        "instructionPictureUrl3": null
                    }
                ],
                "fullName": "John Doe",
                "profilePictureUrl": "https://example.com/profile.jpg",
                "username": "johndoe"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/recipe-details/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipeDetails = try await apiRequest.getRecipeDetails(recipeId: 1)
        
        XCTAssertEqual(recipeDetails.id, 1)
        XCTAssertEqual(recipeDetails.title, "Homemade Pizza")
        XCTAssertEqual(recipeDetails.cookTime, "30 mins")
        XCTAssertEqual(recipeDetails.origin, "Italy")
        XCTAssertEqual(recipeDetails.ingredients.count, 3)
        XCTAssertEqual(recipeDetails.instructions.count, 2)
        XCTAssertEqual(recipeDetails.fullName, "John Doe")
        XCTAssertEqual(recipeDetails.profilePictureUrl, "https://example.com/profile.jpg")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetRecipeDetailsInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/recipe-details/1")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getRecipeDetails(recipeId: 1)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetRecipeDetailsDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/recipe-details/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getRecipeDetails(recipeId: 1)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test User is Following (200 - Returns true)
    func testIsFollowingSuccessTrue() async throws {
        let jsonData = """
            {
                "isFollowing": true
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/is-following/1/2")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let isFollowing = try await apiRequest.isFollowing(followerId: 1, followedId: 2)
        
        XCTAssertTrue(isFollowing, "Expected user to be following but got false")
    }
    
    // Test User is Not Following (200 - Returns false)
    func testIsFollowingSuccessFalse() async throws {
        let jsonData = """
            {
                "isFollowing": false
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/is-following/1/2")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let isFollowing = try await apiRequest.isFollowing(followerId: 1, followedId: 2)
        
        XCTAssertFalse(isFollowing, "Expected user to not be following but got true")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testIsFollowingInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/is-following/1/2")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.isFollowing(followerId: 1, followedId: 2)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testIsFollowingDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/is-following/1/2")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.isFollowing(followerId: 1, followedId: 2)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Following Count Success (200)
    func testGetFollowingCountSuccess() async throws {
        let jsonData = """
            {
                "followingCount": 5
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/1/following")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let count = try await apiRequest.getFollowingCount(userId: 1)
        
        XCTAssertEqual(count, 5, "Expected following count to be 5 but got \(count)")
    }
    
    // Test No Following Users (200 - Zero Count)
    func testGetFollowingCountZero() async throws {
        let jsonData = """
            {
                "followingCount": 0
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/1/following")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let count = try await apiRequest.getFollowingCount(userId: 1)
        
        XCTAssertEqual(count, 0, "Expected following count to be 0 but got \(count)")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetFollowingCountInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/1/following")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getFollowingCount(userId: 1)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetFollowingCountDecodingError() async throws {
        let invalidJsonData = """
            {
                "invalid_field": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/1/following")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getFollowingCount(userId: 1)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Followers Count Success (200)
    func testGetFollowersCountSuccess() async throws {
        let jsonData = """
            {
                "followersCount": 10
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/1/followers")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let count = try await apiRequest.getFollowersCount(userId: 1)
        
        XCTAssertEqual(count, 10, "Expected followers count to be 10 but got \(count)")
    }
    
    // Test No Followers (200 - Zero Count)
    func testGetFollowersCountZero() async throws {
        let jsonData = """
            {
                "followersCount": 0
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/1/followers")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let count = try await apiRequest.getFollowersCount(userId: 1)
        
        XCTAssertEqual(count, 0, "Expected followers count to be 0 but got \(count)")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetFollowersCountInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/1/followers")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getFollowersCount(userId: 1)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetFollowersCountDecodingError() async throws {
        let invalidJsonData = """
            {
                "invalid_field": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/1/followers")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getFollowersCount(userId: 1)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Followers List Success (200)
    func testGetFollowersSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 1,
                    "username": "john_doe",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile1.jpg"
                },
                {
                    "id": 2,
                    "username": "jane_smith",
                    "fullName": "Jane Smith",
                    "profilePictureUrl": "https://example.com/profile2.jpg"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/followers/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let followers = try await apiRequest.getFollowers(userId: 1)
        
        XCTAssertEqual(followers.count, 2)
        XCTAssertEqual(followers[0].id, 1)
        XCTAssertEqual(followers[0].username, "john_doe")
        XCTAssertEqual(followers[0].fullName, "John Doe")
        XCTAssertEqual(followers[0].profilePictureUrl, "https://example.com/profile1.jpg")
    }
    
    // Test No Followers (200 - Empty Array)
    func testGetFollowersEmpty() async throws {
        let jsonData = "[]".data(using: .utf8) // Empty JSON array means no followers
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/followers/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let followers = try await apiRequest.getFollowers(userId: 1)
        
        XCTAssertEqual(followers.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetFollowersInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/followers/1")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getFollowers(userId: 1)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetFollowersDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/followers/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getFollowers(userId: 1)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // ✅ Test Fetch Following List Success (200)
    func testGetFollowingSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 1,
                    "username": "john_doe",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile1.jpg"
                },
                {
                    "id": 2,
                    "username": "jane_smith",
                    "fullName": "Jane Smith",
                    "profilePictureUrl": "https://example.com/profile2.jpg"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/following/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let following = try await apiRequest.getFollowing(userId: 1)
        
        XCTAssertEqual(following.count, 2)
        XCTAssertEqual(following[0].id, 1)
        XCTAssertEqual(following[0].username, "john_doe")
        XCTAssertEqual(following[0].fullName, "John Doe")
        XCTAssertEqual(following[0].profilePictureUrl, "https://example.com/profile1.jpg")
    }
    
    // Test No Following (200 - Empty Array)
    func testGetFollowingEmpty() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/following/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let following = try await apiRequest.getFollowing(userId: 1)
        
        XCTAssertEqual(following.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetFollowingInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/following/1")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getFollowing(userId: 1)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetFollowingDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/following/1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getFollowing(userId: 1)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Comments in Ascending Order Success (200)
    func testGetCommentsOrderAscSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 1,
                    "userId": 2,
                    "recipeId": 101,
                    "comment": "Looks delicious!",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile1.jpg",
                    "createdAt": "2024-01-01T10:00:00Z"
                },
                {
                    "id": 2,
                    "userId": 3,
                    "recipeId": 101,
                    "comment": "Can't wait to try this!",
                    "fullName": "Jane Smith",
                    "profilePictureUrl": "https://example.com/profile2.jpg",
                    "createdAt": "2024-01-01T10:05:00Z"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-asc/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let comments = try await apiRequest.getCommentsOrderAsc(forRecipeId: 101)
        
        XCTAssertEqual(comments.count, 2)
        XCTAssertEqual(comments[0].id, 1)
        XCTAssertEqual(comments[0].comment, "Looks delicious!")
        XCTAssertEqual(comments[0].fullName, "John Doe")
        XCTAssertEqual(comments[0].profilePictureUrl, "https://example.com/profile1.jpg")
        XCTAssertEqual(comments[0].createdAt, "2024-01-01T10:00:00Z")
    }
    
    // Test No Comments (200 - Empty Array)
    func testGetCommentsOrderAscEmpty() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-asc/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let comments = try await apiRequest.getCommentsOrderAsc(forRecipeId: 101)
        
        XCTAssertEqual(comments.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetCommentsOrderAscInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-asc/101")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getCommentsOrderAsc(forRecipeId: 101)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetCommentsOrderAscDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-asc/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getCommentsOrderAsc(forRecipeId: 101)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Comments in Descending Order Success (200)
    func testGetCommentsOrderDescSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 2,
                    "userId": 3,
                    "recipeId": 101,
                    "comment": "Can't wait to try this!",
                    "fullName": "Jane Smith",
                    "profilePictureUrl": "https://example.com/profile2.jpg",
                    "createdAt": "2024-01-01T10:05:00Z"
                },
                {
                    "id": 1,
                    "userId": 2,
                    "recipeId": 101,
                    "comment": "Looks delicious!",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile1.jpg",
                    "createdAt": "2024-01-01T10:00:00Z"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-desc/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let comments = try await apiRequest.getCommentsOrderDesc(forRecipeId: 101)
        
        XCTAssertEqual(comments.count, 2)
        XCTAssertEqual(comments[0].id, 2)
        XCTAssertEqual(comments[0].comment, "Can't wait to try this!")
        XCTAssertEqual(comments[0].fullName, "Jane Smith")
        XCTAssertEqual(comments[0].profilePictureUrl, "https://example.com/profile2.jpg")
        XCTAssertEqual(comments[0].createdAt, "2024-01-01T10:05:00Z")
    }
    
    // Test No Comments (200 - Empty Array)
    func testGetCommentsOrderDescEmpty() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-desc/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let comments = try await apiRequest.getCommentsOrderDesc(forRecipeId: 101)
        
        XCTAssertEqual(comments.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetCommentsOrderDescInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-desc/101")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getCommentsOrderDesc(forRecipeId: 101)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetCommentsOrderDescDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-desc/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getCommentsOrderDesc(forRecipeId: 101)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Comments Ordered by Likes Success (200)
    func testGetCommentsByLikesSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 2,
                    "userId": 3,
                    "recipeId": 101,
                    "comment": "This looks so good!",
                    "fullName": "Jane Smith",
                    "profilePictureUrl": "https://example.com/profile2.jpg",
                    "createdAt": "2024-01-01T10:05:00Z"
                },
                {
                    "id": 1,
                    "userId": 2,
                    "recipeId": 101,
                    "comment": "Amazing recipe!",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile1.jpg",
                    "createdAt": "2024-01-01T10:00:00Z"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-by-likes/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let comments = try await apiRequest.getCommentsByLikes(forRecipeId: 101)
        
        XCTAssertEqual(comments.count, 2)
        XCTAssertEqual(comments[0].id, 2)
        XCTAssertEqual(comments[0].comment, "This looks so good!")
        XCTAssertEqual(comments[0].fullName, "Jane Smith")
        XCTAssertEqual(comments[0].profilePictureUrl, "https://example.com/profile2.jpg")
        XCTAssertEqual(comments[0].createdAt, "2024-01-01T10:05:00Z")
    }
    
    // Test No Comments (200 - Empty Array)
    func testGetCommentsByLikesEmpty() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-by-likes/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let comments = try await apiRequest.getCommentsByLikes(forRecipeId: 101)
        
        XCTAssertEqual(comments.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetCommentsByLikesInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-by-likes/101")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getCommentsByLikes(forRecipeId: 101)
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetCommentsByLikesDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/comments/get-comments-from-recipe-id-order-by-likes/101")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getCommentsByLikes(forRecipeId: 101)
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Most Popular Recipes Success (200)
    func testGetMostPopularRecipesSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 1,
                    "userId": 2,
                    "title": "Spaghetti Bolognese",
                    "recipeCoverPictureUrl1": "https://example.com/recipe1.jpg",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile1.jpg"
                },
                {
                    "id": 2,
                    "userId": 3,
                    "title": "Chicken Teriyaki",
                    "recipeCoverPictureUrl1": "https://example.com/recipe2.jpg",
                    "fullName": "Jane Smith",
                    "profilePictureUrl": "https://example.com/profile2.jpg"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/most-popular-recipes")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getMostPopularRecipes()
        
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes[0].id, 1)
        XCTAssertEqual(recipes[0].title, "Spaghetti Bolognese")
        XCTAssertEqual(recipes[0].recipeCoverPictureUrl1, "https://example.com/recipe1.jpg")
        XCTAssertEqual(recipes[0].fullName, "John Doe")
        XCTAssertEqual(recipes[0].profilePictureUrl, "https://example.com/profile1.jpg")
    }
    
    // Test No Popular Recipes (200 - Empty Array)
    func testGetMostPopularRecipesEmpty() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/most-popular-recipes")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await apiRequest.getMostPopularRecipes()
        
        XCTAssertEqual(recipes.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetMostPopularRecipesInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/most-popular-recipes")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getMostPopularRecipes()
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetMostPopularRecipesDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/recipes/most-popular-recipes")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getMostPopularRecipes()
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
    
    // Test Fetch Users Ordered by Recipe Views Success (200)
    func testGetUsersByRecipeViewsSuccess() async throws {
        let jsonData = """
            [
                {
                    "id": 1,
                    "username": "john_doe",
                    "fullName": "John Doe",
                    "profilePictureUrl": "https://example.com/profile1.jpg"
                },
                {
                    "id": 2,
                    "username": "jane_smith",
                    "fullName": "Jane Smith",
                    "profilePictureUrl": "https://example.com/profile2.jpg"
                }
            ]
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/recipe-views")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let users = try await apiRequest.getUsersByRecipeViews()
        
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[0].id, 1)
        XCTAssertEqual(users[0].username, "john_doe")
        XCTAssertEqual(users[0].fullName, "John Doe")
        XCTAssertEqual(users[0].profilePictureUrl, "https://example.com/profile1.jpg")
    }
    
    // Test No Users Found (200 - Empty Array)
    func testGetUsersByRecipeViewsEmpty() async throws {
        let jsonData = "[]".data(using: .utf8)
        
        MockURLProtocol.mockResponseData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/recipe-views")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let users = try await apiRequest.getUsersByRecipeViews()
        
        XCTAssertEqual(users.count, 0, "Expected empty array but got non-empty result")
    }
    
    // Test Invalid Response (Non-200 Status Code)
    func testGetUsersByRecipeViewsInvalidResponse() async throws {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/recipe-views")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getUsersByRecipeViews()
            XCTFail("Expected APIGetError.invalidResponse but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.invalidResponse)
        }
    }
    
    // Test Decoding Error
    func testGetUsersByRecipeViewsDecodingError() async throws {
        let invalidJsonData = """
            {
                "error": "Invalid response format"
            }
            """.data(using: .utf8)
        
        MockURLProtocol.mockResponseData = invalidJsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/recipe-views")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await apiRequest.getUsersByRecipeViews()
            XCTFail("Expected APIGetError.decodingError but got success")
        } catch let error as APIGetError {
            XCTAssertEqual(error, APIGetError.decodingError)
        }
    }
}
