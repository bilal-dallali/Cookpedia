//
//  CookpediaTests.swift
//  CookpediaTests
//
//  Created by Bilal Dallali on 01/03/2025.
//

import XCTest
import UIKit
import Testing
@testable import Cookpedia

class PostDatasTests: XCTestCase {
    
    var apiPostRequest: APIPostRequest!
    
    override func setUp() {
        super.setUp()
        apiPostRequest = APIPostRequest()
    }

    override func tearDown() {
        apiPostRequest = nil
        super.tearDown()
    }

    func testRegisterUser_Success() {
        let expectation = self.expectation(description: "User registration succeeds")

        let uniqueUsername = "testuser\(Int.random(in: 1000...9999))"
        let uniqueEmail = "test\(Int.random(in: 1000...9999))@example.com"
        let uniquePhoneNumber = "\(Int.random(in: 1000000000...9999999999))"
        
        guard let testImage = UIImage(systemName: "person.crop.circle") else {
            XCTFail("❌ Impossible de charger l'image SF Symbol")
            return
        }
        
        print("✅ Image SF Symbol chargée avec succès")
        
        let mockUser = UserRegistration(
            username: uniqueUsername,
            email: uniqueEmail,
            password: "password123",
            country: "France",
            level: "Beginner",
            salad: false,
            egg: true,
            soup: false,
            meat: true,
            chicken: false,
            seafood: false,
            burger: true,
            pizza: false,
            sushi: false,
            rice: false,
            bread: false,
            fruit: true,
            vegetarian: false,
            vegan: false,
            glutenFree: false,
            nutFree: false,
            dairyFree: false,
            lowCarb: false,
            peanutFree: false,
            keto: false,
            soyFree: false,
            rawFood: false,
            lowFat: false,
            halal: false,
            fullName: "Test User",
            phoneNumber: uniquePhoneNumber,
            gender: "Male",
            date: "1990-01-01",
            city: "Paris",
            profilePictureUrl: "profile-picture"
        )

        apiPostRequest.registerUser(registration: mockUser, profilePicture: testImage, rememberMe: false) { result in
            switch result {
            case .success(let (token, id)):
                XCTAssertNotNil(token, "Token should not be nil")
                XCTAssertGreaterThan(id, 0, "User ID should be greater than zero")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Registration failed: \(error.localizedDescription)")
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testRegisterUser_InvalidEmail() {
        let expectation = self.expectation(description: "User registration fails due to invalid email")
        
        let uniqueUsername = "testuser\(Int.random(in: 1000...9999))"
        let uniquePhoneNumber = "\(Int.random(in: 1000000000...9999999999))"

        let mockUser = UserRegistration(
            username: uniqueUsername,
            email: "dallali-bilal@hotmail.fr",
            password: "password123",
            country: "France",
            level: "Beginner",
            salad: false,
            egg: true,
            soup: false,
            meat: true,
            chicken: false,
            seafood: false,
            burger: true,
            pizza: false,
            sushi: false,
            rice: false,
            bread: false,
            fruit: true,
            vegetarian: false,
            vegan: false,
            glutenFree: false,
            nutFree: false,
            dairyFree: false,
            lowCarb: false,
            peanutFree: false,
            keto: false,
            soyFree: false,
            rawFood: false,
            lowFat: false,
            halal: false,
            fullName: "Test User",
            phoneNumber: uniquePhoneNumber,
            gender: "Male",
            date: "1990-01-01",
            city: "Paris",
            profilePictureUrl: "nil"
        )
        
        apiPostRequest.registerUser(registration: mockUser, profilePicture: nil, rememberMe: false) { result in
            switch result {
            case .success:
                XCTFail("Registration should fail for invalid email")
            case .failure(let error):
                XCTAssertEqual(error, .emailAlreadyExists, "Expected invalid data error")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterUser_UsernameAlreadyExists() {
        let expectation = self.expectation(description: "User registration fails due to existing username")
        
        let uniquePhoneNumber = "\(Int.random(in: 1000000000...9999999999))"
        
        let mockUser = UserRegistration(
            username: "Bilal.d",
            email: "newuser@example.com",
            password: "password123",
            country: "France",
            level: "Beginner",
            salad: false,
            egg: true,
            soup: false,
            meat: true,
            chicken: false,
            seafood: false,
            burger: true,
            pizza: false,
            sushi: false,
            rice: false,
            bread: false,
            fruit: true,
            vegetarian: false,
            vegan: false,
            glutenFree: false,
            nutFree: false,
            dairyFree: false,
            lowCarb: false,
            peanutFree: false,
            keto: false,
            soyFree: false,
            rawFood: false,
            lowFat: false,
            halal: false,
            fullName: "Test User",
            phoneNumber: uniquePhoneNumber,
            gender: "Male",
            date: "1990-01-01",
            city: "Paris",
            profilePictureUrl: "nil"
        )

        apiPostRequest.registerUser(registration: mockUser, profilePicture: nil, rememberMe: false) { result in
            switch result {
            case .success:
                XCTFail("Registration should fail for existing username")
            case .failure(let error):
                XCTAssertEqual(error, .usernameAlreadyExists, "Expected username already exists error")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRegisterUser_PhoneNumberAlreadyExists() {
        let expectation = self.expectation(description: "User registration fails due to existing username")
        
        let uniqueUsername = "test\(Int.random(in: 1000000000...9999999999))"
        let uniqueEmail = "test\(Int.random(in: 1000...9999))@example.com"
        
        let mockUser = UserRegistration(
            username: uniqueUsername,
            email: uniqueEmail,
            password: "password123",
            country: "France",
            level: "Beginner",
            salad: false,
            egg: true,
            soup: false,
            meat: true,
            chicken: false,
            seafood: false,
            burger: true,
            pizza: false,
            sushi: false,
            rice: false,
            bread: false,
            fruit: true,
            vegetarian: false,
            vegan: false,
            glutenFree: false,
            nutFree: false,
            dairyFree: false,
            lowCarb: false,
            peanutFree: false,
            keto: false,
            soyFree: false,
            rawFood: false,
            lowFat: false,
            halal: false,
            fullName: "Test User",
            phoneNumber: "0783258438",
            gender: "Male",
            date: "1990-01-01",
            city: "Paris",
            profilePictureUrl: "nil"
        )

        apiPostRequest.registerUser(registration: mockUser, profilePicture: nil, rememberMe: false) { result in
            switch result {
            case .success:
                XCTFail("Registration should fail for existing username")
            case .failure(let error):
                XCTAssertEqual(error, .phoneNumberAlreadyExists, "Expected phone number already exists error")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginUser_Success() {
        let expectation = self.expectation(description: "Login succeeds")
        
        apiPostRequest.loginUser(email: "axes-empenne.0g@icloud.com", password: "mmeKzB6FxFTpyiz@", rememberMe: false) { result in
            switch result {
            case .success(let (token, id)):
                XCTAssertNotNil(token, "Le token ne doit pas être nil")
                XCTAssertGreaterThan(id, 0, "L'ID doit être valide")
                expectation.fulfill()
            case .failure:
                XCTFail("Le test de login ne devrait pas échouer")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoginUser_Failure() {
        let expectation = self.expectation(description: "Login fails with wrong credentials")
        
        apiPostRequest.loginUser(email: "wrong@example.com", password: "wrongpassword", rememberMe: false) { result in
            switch result {
            case .success:
                XCTFail("Le test devrait échouer")
            case .failure:
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSendResetCode_Success() {
        let expectation = self.expectation(description: "Reset code sent successfully")

        apiPostRequest.sendResetCode(email: "dallali-bilal@hotmail.fr") { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("L'envoi du code de réinitialisation ne devrait pas échouer")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSendResetCode_Failure() {
        let expectation = self.expectation(description: "Fail to send reset code")

        apiPostRequest.sendResetCode(email: "invalid@example.com") { result in
            switch result {
            case .success:
                XCTFail("L'envoi devrait échouer")
            case .failure:
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testVerifyResetCode_Success() {
        let expectation = self.expectation(description: "Reset code verified successfully")

        apiPostRequest.verifyResetCode(email: "dallali-bilal@hotmail.fr", code: "2324") { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("La vérification du code ne devrait pas échouer")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testVerifyResetCode_Failure() {
        let expectation = self.expectation(description: "Fail to verify reset code")

        apiPostRequest.verifyResetCode(email: "test@example.com", code: "0000") { result in
            switch result {
            case .success:
                XCTFail("La vérification devrait échouer")
            case .failure:
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testResetPassword_Success() {
        let expectation = self.expectation(description: "Password reset successfully")

        apiPostRequest.resetPassword(email: "dallali-bilal@hotmail.fr", newPassword: "r6h94mpk5Be5&n!G", resetCode: "2324", rememberMe: false) { result in
            switch result {
            case .success(let (token, id)):
                XCTAssertNotNil(token, "Le token ne doit pas être nil")
                XCTAssertGreaterThan(id, 0, "L'ID doit être valide")
                expectation.fulfill()
            case .failure:
                XCTFail("La réinitialisation du mot de passe ne devrait pas échouer")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testResetPassword_Failure() {
        let expectation = self.expectation(description: "Fail to reset password")

        apiPostRequest.resetPassword(email: "test@example.com", newPassword: "short", resetCode: "000000", rememberMe: false) { result in
            switch result {
            case .success:
                XCTFail("La réinitialisation devrait échouer")
            case .failure:
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
