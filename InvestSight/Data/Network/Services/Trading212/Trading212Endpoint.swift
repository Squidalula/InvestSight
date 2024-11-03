//
//  Trading212Endpoint.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation
import os

enum Trading212Endpoint: Endpoint {
    case portfolio
    case stocks
    case accountInfo(apiKey: String)
    
    var baseURL: String { APIConstants.baseURL }
    
    var path: String {
        switch self {
        case .portfolio: return APIConstants.cashAccountPath
        case .stocks: return APIConstants.portfolioPath
        case .accountInfo: return APIConstants.accountMetadata
        }
    }
    
    var method: HTTPMethod { .get }
    
    var headers: [String: String] {
        switch self {
        case .accountInfo(let apiKey):
            return ["Authorization": apiKey]
        default:
            return ["Authorization": APIConstants.authToken]
        }
    }
}
