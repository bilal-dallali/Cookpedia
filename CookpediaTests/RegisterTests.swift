//
//  RegisterTests.swift
//  CookpediaTests
//
//  Created by Bilal Dallali on 03/03/2025.
//

//import XCTest
//@testable import Cookpedia
//
//final class RegisterTests: XCTestCase {
//    
//    
//    func testSuccessfulRegister() {
//        let expectation = self.expectation(description: "Successful user registration")
//        
//        // 🔥 Simuler la réponse JSON du serveur
//        let jsonResponse = """
//        {
//            "token": "test_token_123",
//            "userId": 9999
//        }
//        """.data(using: .utf8)!
//        
//        do {
//            // 🔄 Décodage JSON simulé comme si c'était une vraie réponse
//            let decodedResponse = try JSONSerialization.jsonObject(with: jsonResponse, options: []) as? [String: Any]
//            
//            // ⚡ Vérifier que les valeurs correspondent
//            XCTAssertEqual(decodedResponse?["token"] as? String, "test_token_123", "Le token ne correspond pas")
//            XCTAssertEqual(decodedResponse?["userId"] as? Int, 9999, "L'ID utilisateur ne correspond pas")
//            
//            expectation.fulfill()
//        } catch {
//            XCTFail("Erreur de décodage JSON: \(error.localizedDescription)")
//        }
//        
//        waitForExpectations(timeout: 2, handler: nil)
//    }
//}
//
//class MockAPIPostRequest: APIPostRequestProtocol {
//    
//    var shouldSucceed: Bool = true // ✅ Permet de tester succès et échec
//    var mockToken: String = "mock_token_123"
//    var mockUserId: Int = 9999
//
//    func registerUser(registration: UserRegistration, profilePicture: Data?, rememberMe: Bool, completion: @escaping (Result<(String, Int), Error>) -> Void) {
//        if shouldSucceed {
//            // 🔥 Simule une réponse JSON comme celle du serveur
//            completion(.success((mockToken, mockUserId)))
//        } else {
//            completion(.failure(APIGetError.invalidResponse))
//        }
//    }
//}
