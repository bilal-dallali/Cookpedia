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
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(baseUrl)/users/registration")!,
                                                       statusCode: 201,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        
        let user = UserRegistration(username: "testUser", email: "test@example.com", password: "password", country: "USA", level: "Beginner", fullName: "Test User", phoneNumber: "1234567890", gender: "Male", date: "2024-01-01", city: "NY", profilePictureUrl: "")
        
        let result = try await apiRequest.registerUser(registration: user, profilePicture: nil, rememberMe: true)
        
        XCTAssertEqual(result.token, "testToken123")
        XCTAssertEqual(result.id, 1)
    }
}
