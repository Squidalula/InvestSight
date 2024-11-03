//
//  APIClient.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation
import os

final class APIClient {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "InvestSight", category: "API")
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw APIError.invalidURL
        }
        
        logger.info("Sending request to \(request.url?.absoluteString ?? "unknown")")
        logger.info("Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        let (data, response) = try await session.data(for: request)
        
        if let rawResponse = String(data: data, encoding: .utf8) {
            logger.info("Raw response: \(rawResponse)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badHTTPResponse
        }
        
        logger.info("Response status code: \(httpResponse.statusCode)")
        if let responseString = String(data: data, encoding: .utf8) {
            logger.info("Response body: \(responseString)")
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                logger.error("Decoding error: \(error.localizedDescription)")
                throw APIError.decodingError(error)
            }
        case 401:
            throw APIError.authorizationError
        case 403:
            throw APIError.authorizationError
        default:
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
}
