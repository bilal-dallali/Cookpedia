//
//  UserSessionTests.swift
//  CookpediaTests
//
//  Created by Bilal Dallali on 14/03/2025.
//

import XCTest
import SwiftData
@testable import Cookpedia

final class UserSessionTests: XCTestCase {
    
    var container: ModelContainer!
    var context: ModelContext!
    
    override func setUpWithError() throws {
        // Initialize an in-memory SwiftData container for testing
        let schema = Schema([UserSession.self])
        container = try ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        context = ModelContext(container)
    }
    
    override func tearDownWithError() throws {
        container = nil
        context = nil
    }
    
    // Test to initialize user session
    func testUserSessionInitialization() {
        let session = UserSession(userId: 1, email: "test@example.com", authToken: "testToken", isRemembered: true)
        
        XCTAssertEqual(session.userId, 1)
        XCTAssertEqual(session.email, "test@example.com")
        XCTAssertEqual(session.authToken, "testToken")
        XCTAssertTrue(session.isRemembered)
    }
    
    // Test saving user session
    func testSavingUserSession() throws {
        let session = UserSession(userId: 1, email: "test@example.com", authToken: "testToken", isRemembered: true)
        
        context.insert(session)
        
        let fetchDescriptor = FetchDescriptor<UserSession>()
        let fetchedSessions = try context.fetch(fetchDescriptor)
        
        XCTAssertEqual(fetchedSessions.count, 1)
        XCTAssertEqual(fetchedSessions.first?.email, "test@example.com")
    }
    
    // Test deleting user session
    func testDeletingUserSession() throws {
        let session = UserSession(userId: 1, email: "test@example.com", authToken: "testToken", isRemembered: true)
        context.insert(session)
        
        context.delete(session)
        
        let fetchDescriptor = FetchDescriptor<UserSession>()
        let fetchedSessions = try context.fetch(fetchDescriptor)
        
        XCTAssertEqual(fetchedSessions.count, 0, "UserSession should be deleted")
    }
}
