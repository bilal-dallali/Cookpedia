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
    static var lastRequest: URLRequest?
    static var lastRequestBody: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        MockURLProtocol.lastRequest = request
        
        if let bodyStream = request.httpBodyStream {
            let data = Data(reading: bodyStream)
            MockURLProtocol.lastRequestBody = data
        } else {
            MockURLProtocol.lastRequestBody = request.httpBody
        }

        if let error = MockURLProtocol.mockError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = MockURLProtocol.mockResponse {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = MockURLProtocol.mockResponseData {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension Data {
    init(reading input: InputStream) {
        self.init()
        
        input.open()
        defer { input.close() }
        
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if read > 0 {
                append(buffer, count: read)
            } else {
                break
            }
        }
    }
}

class NetworkServiceMock: NetworkService {
    
    static var mockResponseData: Data?
    static var mockResponse: URLResponse?
    static var mockError: Error?
    
    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        guard let data = Self.mockResponseData, let response = Self.mockResponse else {
            throw Self.mockError ?? URLError(.badServerResponse, userInfo: [:])
        }
        return (data, response)
    }
    
    
}
