//
//  Stock.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation

struct Stock {
    let id: String
    let symbol: String
    let averagePrice: Decimal
    let currentPrice: Decimal
    let quantity: Decimal
    let unrealizedProfitLoss: Decimal
    let purchaseDate: Date
    let imageURL: URL?
}
