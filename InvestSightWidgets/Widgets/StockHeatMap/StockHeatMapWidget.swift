import WidgetKit
import SwiftUI

struct StockHeatMapWidget: Widget {
    static let kind: String = "StockHeatMapWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Self.kind, provider: StockHeatMapProvider()) { entry in
            StockHeatMapWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Stock Heat Map")
        .description("View your portfolio stocks performance")
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    StockHeatMapWidget()
} timeline: {
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
    
    StockEntry(
        date: .now,
        stocks: [stock],
        portfolioTotalValue: stock.currentPrice * stock.quantity
    )
}
