//
//  MockURLProtocol.swift
//  CookpediaTests
//
//  Created by Bilal Dallali on 10/03/2025.
//

import Foundation
@testable import Cookpedia

// Mock URL protocol to handle mock data as response for the tests
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
