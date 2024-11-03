//
//  Stock.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation

struct T212Stock: Codable, Hashable {
    let averagePrice: Double
    let currentPrice: Double
    let frontend: String
    let fxPpl: Double
    let initialFillDate: String
    let maxBuy: Double
    let maxSell: Double
    let pieQuantity: Double
    let ppl: Double
    let quantity: Double
    let ticker: String

    
    // Add mapping to domain model
    func toDomain() -> Stock {
        return Stock(
            id: ticker,
            symbol: ticker.replacingOccurrences(of: "_US_EQ", with: ""),
            averagePrice: Decimal(averagePrice),
            currentPrice: Decimal(currentPrice),
            quantity: Decimal(quantity),
            unrealizedProfitLoss: Decimal(ppl),
            purchaseDate: ISO8601DateFormatter().date(from: initialFillDate) ?? Date(),
            imageURL: URL(string: "https://trading212equities.s3.eu-central-1.amazonaws.com/\(ticker).png")
        )
    }
}
