//
//  MockApiPostRequest.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 02/03/2025.
//

//import Foundation
//
//class MockURLSession: URLSession {
//    var mockResponseData: Data?
//    var mockResponse: URLResponse?
//    var mockError: Error?
//
//    override func dataTask(
//        with request: URLRequest,
//        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
//    ) -> URLSessionDataTask {
//        
//        return MockURLSessionDataTask {
//            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { // ✅ Ajoute un léger délai
//                completionHandler(self.mockResponseData, self.mockResponse, self.mockError)
//            }
//        }
//    }
//}
//
//class MockURLSessionDataTask: URLSessionDataTask {
//    private let closure: () -> Void
//    
//    init(closure: @escaping () -> Void) {
//        self.closure = closure
//    }
//    
//    override func resume() {
//        closure()
//    }
//}
//
