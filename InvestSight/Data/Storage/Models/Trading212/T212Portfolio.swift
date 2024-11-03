//
//  T212Portfolio.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation

struct T212Portfolio: Codable {
    let blocked: Int?
    let free: Double
    let invested: Double
    let pieCash: Double
    let ppl: Double
    let result: Double
    let total: Double
    
    enum CodingKeys: String, CodingKey {
        case blocked
        case free
        case invested
        case pieCash = "pieCash"
        case ppl
        case result
        case total
    }
    
    func toDomain(with stocks: [Stock]) -> Portfolio {
        return Portfolio(
            cash: Decimal(free),
            invested: Decimal(invested),
            totalValue: Decimal(total),
            unrealizedProfitLoss: Decimal(ppl),
            stocks: stocks
        )
    }
}
