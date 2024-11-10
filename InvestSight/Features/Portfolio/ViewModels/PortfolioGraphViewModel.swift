import Foundation

@MainActor
final class PortfolioGraphViewModel: ObservableObject {
    private let portfolioHistoryService: PortfolioHistoryService
    
    @Published private(set) var entries: [PortfolioHistoryEntry] = []
    @Published var selectedTimeRange: TimeRange = .day
    let portfolio: Portfolio
    
    init(portfolioHistoryService: PortfolioHistoryService, portfolio: Portfolio) {
        self.portfolioHistoryService = portfolioHistoryService
        self.portfolio = portfolio
    }
    
    func loadHistory() async {
        let historyEntries = await portfolioHistoryService.getHistory(for: selectedTimeRange)
        
        if historyEntries.isEmpty {
            // Create mock entries for a straight line using current portfolio value
            let calendar = Calendar.current
            let now = Date()
            var mockEntries: [PortfolioHistoryEntry] = []
            
            // Create 24 entries for the last 24 hours
            for hour in 0..<24 {
                if let date = calendar.date(byAdding: .hour, value: -hour, to: now) {
                    mockEntries.append(PortfolioHistoryEntry(
                        timestamp: date,
                        totalValue: portfolio.totalValue,
                        invested: portfolio.invested,
                        unrealizedProfitLoss: portfolio.unrealizedProfitLoss
                    ))
                }
            }
            
            entries = mockEntries.reversed()
        } else {
            entries = historyEntries
        }
    }
}
