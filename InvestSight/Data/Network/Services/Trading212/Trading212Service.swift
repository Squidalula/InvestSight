//
//  Trading212Service.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation
import os

final class Trading212Service: Trading212ServiceProtocol {
    private let apiClient: APIClient
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "InvestSight", category: "Trading212")
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchPortfolio() async throws -> T212Portfolio {
        return try await apiClient.request(Trading212Endpoint.portfolio)
    }
    
    func fetchStocks() async throws -> [T212Stock] {
        return try await apiClient.request(Trading212Endpoint.stocks)
    }
    
    func validateApiKey(_ apiKey: String) async throws -> Bool {
        let _: EmptyResponse = try await apiClient.request(Trading212Endpoint.accountInfo(apiKey: apiKey))
        return true
    }
}
