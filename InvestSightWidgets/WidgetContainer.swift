import Foundation

@MainActor
final class WidgetContainer {
    static let shared = WidgetContainer()
    
    let trading212Service: Trading212ServiceProtocol
    let stockCacheService: StockCacheService
    
    private init() {
        let apiClient = APIClient()
        self.trading212Service = Trading212Service(apiClient: apiClient)
        self.stockCacheService = StockCacheService(dateProvider: LiveDateProvider())
    }
} 