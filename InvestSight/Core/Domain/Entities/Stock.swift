//
//  Stock.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation

public struct Stock: Equatable, Identifiable, Codable {
    public let id: String
    public let symbol: String
    public let averagePrice: Decimal
    public let currentPrice: Decimal
    public let quantity: Decimal
    public let unrealizedProfitLoss: Decimal
    public let purchaseDate: Date
    public let imageURL: URL?
    
    public init(id: String,
         symbol: String,
         averagePrice: Decimal,
         currentPrice: Decimal,
         quantity: Decimal,
         unrealizedProfitLoss: Decimal,
         purchaseDate: Date,
         imageURL: URL?) {
        self.id = id
        self.symbol = symbol
        self.averagePrice = averagePrice
        self.currentPrice = currentPrice
        self.quantity = quantity
        self.unrealizedProfitLoss = unrealizedProfitLoss
        self.purchaseDate = purchaseDate
        self.imageURL = imageURL
    }
    
    public static func == (lhs: Stock, rhs: Stock) -> Bool {
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
