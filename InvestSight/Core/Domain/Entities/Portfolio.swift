//
//  Portfolio.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation

struct Portfolio {
    let cash: Decimal
    let invested: Decimal
    let totalValue: Decimal
    let unrealizedProfitLoss: Decimal
    let stocks: [Stock]
    
    var unrealizedPLPercentage: Decimal {
        guard invested != 0 else { return 0 }
        return (unrealizedProfitLoss / invested) * 100
    }
}
