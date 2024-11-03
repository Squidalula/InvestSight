import Foundation

actor StockCacheService {
    struct StockBasicInfo {
        let id: String
        let symbol: String
        let imageURL: URL?
        let lastUpdated: Date
    }
    
    private struct CacheEntry {
        let info: StockBasicInfo
        let expirationDate: Date
        let createdAt: Date
    }
    
    static let shared = StockCacheService()
    
    private var stockInfoCache: [String: CacheEntry] = [:]
    private let cacheLifetime: TimeInterval = 3600 // 1 hour
    private let maxCacheSize: Int = 100
    
    private let dateProvider: DateProviding
    
    init(dateProvider: DateProviding = LiveDateProvider()) {
        self.dateProvider = dateProvider
    }
    
    func getStockInfo(for symbol: String) -> StockBasicInfo? {
        cleanupExpiredEntries()
        
        let cleanSymbol = symbol.replacingOccurrences(of: "_US_EQ", with: "")
        guard let entry = stockInfoCache[cleanSymbol],
              entry.expirationDate > dateProvider.now else {
            stockInfoCache[cleanSymbol] = nil
            return nil
        }
        return entry.info
    }
    
    func cacheStockInfo(from stock: Stock) {
        cleanupExpiredEntries()
        enforceMaxCacheSize()
        
        let info = StockBasicInfo(
            id: stock.id,
            symbol: stock.symbol,
            imageURL: stock.imageURL,
            lastUpdated: dateProvider.now
        )
        
        stockInfoCache[stock.symbol] = CacheEntry(
            info: info,
            expirationDate: dateProvider.now.addingTimeInterval(cacheLifetime),
            createdAt: dateProvider.now
        )
    }
    
    private func cleanupExpiredEntries() {
        stockInfoCache = stockInfoCache.filter { $0.value.expirationDate > dateProvider.now }
    }
    
    private func enforceMaxCacheSize() {
        guard stockInfoCache.count >= maxCacheSize else { return }
        
        // Remove oldest entries when cache is full
        let sortedEntries = stockInfoCache.sorted { $0.value.createdAt < $1.value.createdAt }
        let entriesToRemove = sortedEntries.prefix(stockInfoCache.count - maxCacheSize + 1)
        entriesToRemove.forEach { stockInfoCache.removeValue(forKey: $0.key) }
    }
    
    func clearCache() {
        stockInfoCache.removeAll()
    }
}
