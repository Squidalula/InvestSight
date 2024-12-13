import WidgetKit
import SwiftUI

public struct StockEntry: TimelineEntry {
    public let date: Date
    public let stocks: [Stock]
    public let portfolioTotalValue: Decimal
    
    public init(date: Date, stocks: [Stock], portfolioTotalValue: Decimal) {
        self.date = date
        self.stocks = stocks
        self.portfolioTotalValue = portfolioTotalValue
    }
}

public struct StockHeatMapProvider: TimelineProvider {
    private let userDefaults: UserDefaults
    
    public init() {
        self.userDefaults = UserDefaults(suiteName: "group.co.tiagoafonso.InvestSight") ?? .standard
    }
    
    public func placeholder(in context: Context) -> StockEntry {
        let stock = Stock(
            id: "AAPL_US_EQ",
            symbol: "AAPL",
            averagePrice: 150.0,
            currentPrice: 170.0,
            quantity: 10,
            unrealizedProfitLoss: 200.0,
            purchaseDate: Date(),
            imageURL: URL(string: "https://trading212equities.s3.eu-central-1.amazonaws.com/AAPL_US_EQ.png")
        )
        
        return StockEntry(
            date: .now,
            stocks: [stock],
            portfolioTotalValue: stock.currentPrice * stock.quantity
        )
    }
    
    public func getSnapshot(in context: Context, completion: @escaping (StockEntry) -> Void) {
        print("Widget getSnapshot called")
        if context.isPreview {
            let stock = Stock(
                id: "AAPL_US_EQ",
                symbol: "AAPL",
                averagePrice: 150.0,
                currentPrice: 170.0,
                quantity: 10,
                unrealizedProfitLoss: 200.0,
                purchaseDate: Date(),
                imageURL: URL(string: "https://trading212equities.s3.eu-central-1.amazonaws.com/AAPL_US_EQ.png")
            )
            
            let entry = StockEntry(
                date: .now,
                stocks: [stock],
                portfolioTotalValue: stock.currentPrice * stock.quantity
            )
            completion(entry)
        } else {
            if let stocksData = userDefaults.data(forKey: "widget_stocks") {
                print("Found widget_stocks data")
                if let stocks = try? JSONDecoder().decode([Stock].self, from: stocksData) {
                    print("Successfully decoded \(stocks.count) stocks")
                    let totalValue = stocks.reduce(Decimal(0)) { $0 + ($1.currentPrice * $1.quantity) }
                    let entry = StockEntry(date: Date(), stocks: stocks, portfolioTotalValue: totalValue)
                    completion(entry)
                } else {
                    print("Failed to decode stocks data")
                    let entry = StockEntry(date: Date(), stocks: [], portfolioTotalValue: 0)
                    completion(entry)
                }
            } else {
                print("No widget_stocks data found in UserDefaults")
                let entry = StockEntry(date: Date(), stocks: [], portfolioTotalValue: 0)
                completion(entry)
            }
        }
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<StockEntry>) -> Void) {
        Task {
            // Fetch stocks from UserDefaults
            if let stocksData = userDefaults.data(forKey: "widget_stocks"),
               let stocks = try? JSONDecoder().decode([Stock].self, from: stocksData) {
                
                let totalValue = stocks.reduce(Decimal(0)) { $0 + ($1.currentPrice * $1.quantity) }
                
                let entry = StockEntry(
                    date: Date(),
                    stocks: stocks,
                    portfolioTotalValue: totalValue
                )
                
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } else {
                // Return empty timeline if no data
                let entry = StockEntry(date: Date(), stocks: [], portfolioTotalValue: 0)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
                completion(timeline)
            }
        }
    }
}
