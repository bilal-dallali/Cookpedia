//
//  NetworkSrvice.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 10/03/2025.
//

import Foundation

protocol NetworkService {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkService {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request)
    }
}
