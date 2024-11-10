import Foundation
import SwiftUI

@MainActor
final class PortfolioViewModel: ObservableObject, PortfolioRefreshable {
    private let trading212Service: Trading212ServiceProtocol
    private let cacheService: StockCacheService
    private let portfolioHistoryService: PortfolioHistoryService
    private var currentTask: Task<Void, Never>?
    private var lastRefreshTime: Date?
    private let minimumRefreshInterval: TimeInterval = 5
    
    @Published private(set) var state: PortfolioState = .idle
    
    init(trading212Service: Trading212ServiceProtocol,
         cacheService: StockCacheService,
         portfolioHistoryService: PortfolioHistoryService) {
        self.trading212Service = trading212Service
        self.cacheService = cacheService
        self.portfolioHistoryService = portfolioHistoryService
    }
    
    public func refresh(includeCache: Bool) async {
        if let lastRefresh = lastRefreshTime,
           Date().timeIntervalSince(lastRefresh) < minimumRefreshInterval {
            return
        }
        
        currentTask?.cancel()
        
        currentTask = Task {
            guard !Task.isCancelled else { return }
            
            if case .loaded(let currentPortfolio) = state {
                state = .refreshing(currentPortfolio)
            } else {
                state = .loading
            }
            
            do {
                let t212Portfolio = try await fetchWithRetry {
                    try await trading212Service.fetchPortfolio()
                }
                guard !Task.isCancelled else { return }
                
                var stocks: [Stock]
                
                if includeCache {
                    let t212Stocks = try await fetchWithRetry {
                        try await trading212Service.fetchStocks()
                    }
                    guard !Task.isCancelled else { return }
                    
                    stocks = t212Stocks.map { $0.toDomain() }
                    await cacheNewStocks(stocks)
                } else {
                    stocks = await getStocksFromCache(for: t212Portfolio)
                }
                
                let domainPortfolio = t212Portfolio.toDomain(with: stocks)
                await portfolioHistoryService.addEntry(from: domainPortfolio)
                
                state = .loaded(domainPortfolio)
                lastRefreshTime = Date()
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error)
                lastRefreshTime = Date()
            }
        }
        
        await currentTask?.value
    }
    
    private func getStocksFromCache(for t212Portfolio: T212Portfolio) async -> [Stock] {
        var cachedStocks: [Stock] = []
        
        // Get stocks from the T212 service directly
        let t212Stocks = try? await trading212Service.fetchStocks()
        guard let stocks = t212Stocks else { return [] }
        
        for t212Stock in stocks {
            if let cachedInfo = await cacheService.getStockInfo(for: t212Stock.ticker) {
                let stock = Stock(
                    id: t212Stock.ticker,
                    symbol: t212Stock.ticker.replacingOccurrences(of: "_US_EQ", with: ""),
                    averagePrice: Decimal(t212Stock.averagePrice),
                    currentPrice: Decimal(t212Stock.currentPrice),
                    quantity: Decimal(t212Stock.quantity),
                    unrealizedProfitLoss: Decimal(t212Stock.ppl),
                    purchaseDate: ISO8601DateFormatter().date(from: t212Stock.initialFillDate) ?? Date(),
                    imageURL: cachedInfo.imageURL
                )
                cachedStocks.append(stock)
            }
        }
        
        return cachedStocks
    }
    
    private func cacheNewStocks(_ stocks: [Stock]) async {
        for stock in stocks {
            await cacheService.cacheStockInfo(from: stock)
        }
    }
    
    private func fetchWithRetry<T>(_ operation: () async throws -> T) async throws -> T {
        let maxRetries = 3
        var retryCount = 0
        var lastError: Error?
        
        while retryCount < maxRetries {
            do {
                if retryCount > 0 {
                    try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(retryCount))) * 1_000_000_000)
                }
                return try await operation()
            } catch {
                lastError = error
                retryCount += 1
            }
        }
        
        throw lastError ?? NSError(domain: "PortfolioViewModel", code: -1, userInfo: nil)
    }
} 