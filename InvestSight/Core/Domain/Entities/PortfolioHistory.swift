import Foundation

struct PortfolioHistoryEntry: Codable {
    let timestamp: Date
    let totalValue: Decimal
    let invested: Decimal
    let unrealizedProfitLoss: Decimal
}

struct PortfolioHistory: Codable {
    private var entriesByTimeRange: [String: [PortfolioHistoryEntry]]
    
    init() {
        self.entriesByTimeRange = Dictionary(uniqueKeysWithValues: 
            TimeRange.allCases.map { ($0.rawValue, []) }
        )
    }
    
    mutating func addEntry(_ entry: PortfolioHistoryEntry, for timeRange: TimeRange) {
        var entries = entriesByTimeRange[timeRange.rawValue] ?? []
        entries.append(entry)
        
        // Keep only the latest maxEntries
        if entries.count > timeRange.maxEntries {
            entries.removeFirst(entries.count - timeRange.maxEntries)
        }
        
        entriesByTimeRange[timeRange.rawValue] = entries
    }
    
    func getEntries(for timeRange: TimeRange) -> [PortfolioHistoryEntry] {
        return entriesByTimeRange[timeRange.rawValue] ?? []
    }
}

enum TimeRange: String, CaseIterable {
    case day = "1D"
    case week = "1W"
    case month = "1M"
    case year = "1Y"
    case all = "MAX"
    
    var storageInterval: TimeInterval {
        switch self {
        case .day: return 15 * 60 // 15 minutes
        case .week: return 60 * 60 // 1 hour
        case .month: return 4 * 60 * 60 // 4 hours
        case .year: return 4 * 24 * 60 * 60 // 4 days
        case .all: return 30 * 24 * 60 * 60 // ~30 days (monthly)
        }
    }
    
    var maxEntries: Int {
        switch self {
        case .day: return 96 // 24h * 4 (15-min intervals)
        case .week: return 168 // 7 days * 24h
        case .month: return 180 // 30 days * 6 (4-hour intervals)
        case .year: return 91 // 365/4 days
        case .all: return 120 // 10 years of monthly data
        }
    }
    
    func shouldAddNewEntry(lastEntry: Date?, now: Date) -> Bool {
        guard let lastEntry = lastEntry else { return true }
        
        switch self {
        case .day, .week, .month:
            return now.timeIntervalSince(lastEntry) >= storageInterval
        case .year:
            // Check if it's 1 AM and if enough days have passed
            return now.hour == 1 && 
                   now.timeIntervalSince(lastEntry) >= storageInterval
        case .all:
            // Check if it's the first day of the month
            return now.day == 1 && 
                   (lastEntry.month != now.month || lastEntry.year != now.year)
        }
    }
}
