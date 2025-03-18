//
//  MockURLProtocol.swift
//  CookpediaTests
//
//  Created by Bilal Dallali on 10/03/2025.
//

import Foundation
@testable import Cookpedia

class MockURLProtocol: URLProtocol {
    
    static var mockResponseData: Data?
    static var mockResponse: URLResponse?
    static var mockError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = MockURLProtocol.mockResponse {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = MockURLProtocol.mockResponseData {
                _ = String(data: data, encoding: .utf8) ?? "Invalid JSON"
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

//class NetworkServiceMock: NetworkService {
//    
//    static var mockResponseData: Data?
//    static var mockResponse: URLResponse?
//    static var mockError: Error?
//    
//    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
//        guard let data = Self.mockResponseData, let response = Self.mockResponse else {
//            throw Self.mockError ?? URLError(.badServerResponse, userInfo: [:])
//        }
//        return (data, response)
//    }
//    
//    
//}
