//
//  Portfolio.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation

struct Portfolio: Equatable {
    let cash: Decimal
    let invested: Decimal
    let totalValue: Decimal
    let unrealizedProfitLoss: Decimal
    let stocks: [Stock]
    
    var unrealizedPLPercentage: Decimal {
        guard invested != 0 else { return 0 }
        return (unrealizedProfitLoss / invested) * 100
    }
    
    static func == (lhs: Portfolio, rhs: Portfolio) -> Bool {
        return lhs.cash == rhs.cash &&
               lhs.invested == rhs.invested &&
               lhs.totalValue == rhs.totalValue &&
               lhs.unrealizedProfitLoss == rhs.unrealizedProfitLoss &&
               lhs.stocks == rhs.stocks
    }
}
