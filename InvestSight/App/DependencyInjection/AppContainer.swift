//
//  AppContainer.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import Foundation
import SwiftUI

@MainActor
final class AppContainer: ObservableObject {
    // MARK: - Services
    let trading212Service: Trading212ServiceProtocol
    
    // MARK: - ViewModels
    let portfolioViewModel: PortfolioViewModel
    
    // MARK: - Initialization
    init() {
        // Initialize API Client
        let apiClient = APIClient()
        
        // Initialize Services
        self.trading212Service = Trading212Service(apiClient: apiClient)
        
        // Initialize ViewModels
        self.portfolioViewModel = PortfolioViewModel(trading212Service: self.trading212Service)
    }
}
