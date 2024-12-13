import SwiftUI

public struct StockHeatMapWidgetView: View {
    let entry: StockEntry
    
    private var sortedStocks: [Stock] {
        entry.stocks.sorted { 
            ($0.currentPrice * $0.quantity) > ($1.currentPrice * $1.quantity)
        }
    }
    
    private var gridLayout: [GridItem] {
        let stockCount = min(sortedStocks.count, 6)
        switch stockCount {
        case 1: return [GridItem(.flexible())]
        case 2: return [GridItem(.flexible()), GridItem(.flexible())]
        case 3...4: return [GridItem(.flexible()), GridItem(.flexible())]
        default: return [GridItem(.flexible()), GridItem(.flexible())]
        }
    }
    
    public var body: some View {
        LazyVGrid(columns: gridLayout, spacing: 8) {
            ForEach(Array(sortedStocks.prefix(6).enumerated()), id: \.element.id) { index, stock in
                StockHeatMapCell(
                    stock: stock,
                    portfolioTotalValue: entry.portfolioTotalValue,
                    isLargeCell: index < 2
                )
            }
        }
        .padding(8)
    }
}

struct StockHeatMapCell: View {
    let stock: Stock
    let portfolioTotalValue: Decimal
    let isLargeCell: Bool
    
    private var percentageChange: Double {
        let change = ((stock.currentPrice - stock.averagePrice) / stock.averagePrice) * 100
        return (change as NSDecimalNumber).doubleValue
    }
    
    private var backgroundColor: Color {
        let baseColor = percentageChange >= 0 ? Color.green : Color.red
        return baseColor.opacity(min(abs(percentageChange) / 10, 0.8))
    }
    
    private var cellHeight: CGFloat {
        isLargeCell ? 80 : 70
    }
    
    var body: some View {
        HStack(spacing: 4) {
            AsyncImage(url: stock.imageURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .frame(width: isLargeCell ? 24 : 20, height: isLargeCell ? 24 : 20)
            .clipShape(Circle())
            
            Text(stock.symbol.replacingOccurrences(of: "_US_EQ", with: ""))
                .font(isLargeCell ? .callout : .caption)
                .bold()
                .lineLimit(1)
            
            Spacer()
            
            Text("\(percentageChange.formatted(.number.precision(.fractionLength(1))))%")
                .font(isLargeCell ? .caption : .caption2)
                .foregroundColor(.white)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .frame(height: cellHeight)
        .background(backgroundColor)
        .cornerRadius(8)
    }
} 