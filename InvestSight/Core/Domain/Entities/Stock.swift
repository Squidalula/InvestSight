//
//  Stock.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation

struct Stock: Equatable {
    let id: String
    let symbol: String
    let averagePrice: Decimal
    let currentPrice: Decimal
    let quantity: Decimal
    let unrealizedProfitLoss: Decimal
    let purchaseDate: Date
    let imageURL: URL?
    
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.id == rhs.id &&
               lhs.symbol == rhs.symbol &&
               lhs.averagePrice == rhs.averagePrice &&
               lhs.currentPrice == rhs.currentPrice &&
               lhs.quantity == rhs.quantity &&
               lhs.unrealizedProfitLoss == rhs.unrealizedProfitLoss &&
               lhs.purchaseDate == rhs.purchaseDate &&
               lhs.imageURL == rhs.imageURL
    }
}
