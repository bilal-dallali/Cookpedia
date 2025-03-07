//
//  CookpediaTests.swift
//  CookpediaTests
//
//  Created by Bilal Dallali on 01/03/2025.
//

//import XCTest
//@testable import Cookpedia
//
//// ✅ Ajout de la fonction ici, avant la classe de test
//private func createMockUser() -> UserRegistration {
//    return UserRegistration(
//        username: "testuser",
//        email: "test@example.com",
//        password: "password123",
//        country: "France",
//        level: "Beginner",
//        salad: false,
//        egg: true,
//        soup: false,
//        meat: true,
//        chicken: false,
//        seafood: false,
//        burger: true,
//        pizza: false,
//        sushi: false,
//        rice: false,
//        bread: false,
//        fruit: true,
//        vegetarian: false,
//        vegan: false,
//        glutenFree: false,
//        nutFree: false,
//        dairyFree: false,
//        lowCarb: false,
//        peanutFree: false,
//        keto: false,
//        soyFree: false,
//        rawFood: false,
//        lowFat: false,
//        halal: false,
//        fullName: "Test User",
//        phoneNumber: "123456789",
//        gender: "Male",
//        date: "1990-01-01",
//        city: "Paris",
//        profilePictureUrl: "nil"
//    )
//}
//
//class PostDatasTests: XCTestCase {
//
//    var postData: APIPostRequest!
//    var mockSession: MockURLSession!
//
//    override func setUp() {
//        super.setUp()
//        mockSession = MockURLSession() // ✅ On utilise une session mockée
//        postData = APIPostRequest()  // ✅ On teste PostDatas.swift
//    }
//
//    override func tearDown() {
//        postData = nil
//        mockSession = nil
//        super.tearDown()
//    }
//
//    func testRegisterUser_Success() {
//        let expectation = self.expectation(description: "Register user succeeds")
//
//        let mockUser = createMockUser()
//        let mockImage = UIImage(systemName: "person.circle")
//
//        print("📤 Envoi de la requête de test...") // ✅ Debug
//
//        postData.registerUser(registration: mockUser, profilePicture: mockImage, rememberMe: false) { result in
//            print("📩 Réponse reçue !") // ✅ Debug
//
//            switch result {
//            case .success(let (token, id)):
//                print("✅ Succès ! Token: \(token), ID: \(id)") // ✅ Debug
//                XCTAssertEqual(token, "mock_token_123")
//                XCTAssertEqual(id, 12345)
//                expectation.fulfill()
//            case .failure:
//                XCTFail("Le test de registration ne devrait pas échouer")
//            }
//        }
//
//        waitForExpectations(timeout: 5, handler: nil) // ✅ Augmenté à 5s
//    }
//}
