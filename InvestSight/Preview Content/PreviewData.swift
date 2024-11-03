import Foundation

struct PreviewData {
    static let mockPortfolio = Portfolio(
        cash: 1000,
        invested: 10000,
        totalValue: 10500,
        unrealizedProfitLoss: 500,
        stocks: []
    )
    
    static let mockHistoryService: PortfolioHistoryService = {
        let mockDate = Date()
        let calendar = Calendar.current
        let mockProvider = MockDateProvider(staticDate: mockDate)
        let service = PortfolioHistoryService(
            userDefaults: UserDefaults(suiteName: "preview")!,
            dateProvider: mockProvider
        )
        
        Task {
            // Generate entries from oldest to newest (24 hours ago to now)
            for hourOffset in (0...23).reversed() {
                let entryDate = calendar.date(byAdding: .hour, value: -hourOffset, to: mockDate)!
                let mockProvider = MockDateProvider(staticDate: entryDate)
                let service = PortfolioHistoryService(
                    userDefaults: UserDefaults(suiteName: "preview")!,
                    dateProvider: mockProvider
                )
                
                // Create a smooth progression from 10000 to 10500
                let progress = Double(23 - hourOffset) / 23.0
                let baseValue = 10000.0 + (500.0 * progress)
                
                // Add small random variations (±0.5%)
                let randomFactor = Double.random(in: 0.995...1.005)
                let finalValue = baseValue * randomFactor
                
                await service.addEntry(from: Portfolio(
                    cash: 1000,
                    invested: 10000,
                    totalValue: Decimal(finalValue),
                    unrealizedProfitLoss: Decimal(finalValue - 10000),
                    stocks: []
                ))
            }
        }
        
        return service
    }()
}
