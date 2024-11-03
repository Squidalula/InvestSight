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
    // MARK: - Core
    private let dateProvider: DateProviding
    
    // MARK: - Services
    let trading212Service: Trading212ServiceProtocol
    let stockCacheService: StockCacheService
    let portfolioHistoryService: PortfolioHistoryService
    let backgroundTaskService: BackgroundTaskService
    
    // MARK: - ViewModels
    let portfolioViewModel: PortfolioViewModel
    
    // MARK: - Initialization
    init() {
        // Initialize Core
        self.dateProvider = LiveDateProvider()
        
        // Initialize Services
        let apiClient = APIClient()
        self.stockCacheService = StockCacheService(dateProvider: dateProvider)
        self.portfolioHistoryService = PortfolioHistoryService(dateProvider: dateProvider)
        self.trading212Service = Trading212Service(apiClient: apiClient)
        
        // Initialize ViewModels
        self.portfolioViewModel = PortfolioViewModel(
            trading212Service: trading212Service,
            cacheService: stockCacheService,
            portfolioHistoryService: portfolioHistoryService
        )
        
        // Initialize Background Task Service
        self.backgroundTaskService = BackgroundTaskService(portfolioViewModel: portfolioViewModel)
    }
}
