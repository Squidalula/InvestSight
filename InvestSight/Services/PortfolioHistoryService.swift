import Foundation

actor PortfolioHistoryService {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let dateProvider: DateProviding
    private let storageKey = "portfolio_history"
    
    // Store last entry timestamps
    private var lastEntryTimes: [TimeRange: Date] = [:]
    
    init(userDefaults: UserDefaults = .standard,
         dateProvider: DateProviding = LiveDateProvider()) {
        self.userDefaults = userDefaults
        self.dateProvider = dateProvider
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    func addEntry(from portfolio: Portfolio) {
        var history = getCurrentHistory()
        let now = dateProvider.now
        
        let entry = PortfolioHistoryEntry(
            timestamp: now,
            totalValue: portfolio.totalValue,
            invested: portfolio.invested,
            unrealizedProfitLoss: portfolio.unrealizedProfitLoss
        )
        
        // Add entry for each timeframe if needed
        for timeRange in TimeRange.allCases {
            if timeRange.shouldAddNewEntry(
                lastEntry: lastEntryTimes[timeRange],
                now: now
            ) {
                history.addEntry(entry, for: timeRange)
                lastEntryTimes[timeRange] = now
            }
        }
        
        saveHistory(history)
    }
    
    func getHistory(for timeRange: TimeRange) -> [PortfolioHistoryEntry] {
        let history = getCurrentHistory()
        return history.getEntries(for: timeRange)
    }
    
    private func getCurrentHistory() -> PortfolioHistory {
        guard let data = userDefaults.data(forKey: storageKey),
              let history = try? decoder.decode(PortfolioHistory.self, from: data) else {
            return PortfolioHistory()
        }
        return history
    }
    
    private func saveHistory(_ history: PortfolioHistory) {
        guard let data = try? encoder.encode(history) else { return }
        userDefaults.set(data, forKey: storageKey)
    }
}
