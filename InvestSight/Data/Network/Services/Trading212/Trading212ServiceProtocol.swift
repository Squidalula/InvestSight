//
//  Trading212ServiceProtocol.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation

protocol Trading212ServiceProtocol {
    func fetchPortfolio() async throws -> T212Portfolio
    func fetchStocks() async throws -> [T212Stock]
    func validateApiKey(_ apiKey: String) async throws -> Bool
}
