import SwiftUI

struct StockRowView: View {
    let stock: Stock
    
    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private let wholeNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    private func formatQuantity(_ quantity: Decimal) -> String {
        let doubleValue = (quantity as NSDecimalNumber).doubleValue
        if doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
            return wholeNumberFormatter.string(from: NSDecimalNumber(decimal: quantity)) ?? "0"
        } else {
            return decimalFormatter.string(from: NSDecimalNumber(decimal: quantity)) ?? "0.00"
        }
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: stock.imageURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .frame(width: 45, height: 45)
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.symbol.replacingOccurrences(of: "_US_EQ", with: ""))
                    .font(.headline)
                Text("\(formatQuantity(stock.quantity)) \(stock.quantity == 1 ? "share" : "shares")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("€\(decimalFormatter.string(from: NSDecimalNumber(decimal: stock.currentPrice * stock.quantity)) ?? "0.00")")
                    .font(.headline)
                
                let percentageChange = ((stock.currentPrice - stock.averagePrice) / stock.averagePrice) * 100
                Text("\(percentageChange >= 0 ? "↑" : "↓") \(decimalFormatter.string(from: NSDecimalNumber(decimal: abs(percentageChange))) ?? "0.00")%")
                    .font(.subheadline)
                    .foregroundColor(percentageChange >= 0 ? Color(hex: "34A853") : Color(hex: "FF5A5F"))
            }
        }
        .padding(.vertical, 12)
    }
}

extension Decimal {
    var isWholeNumber: Bool {
        let doubleValue = (self as NSDecimalNumber).doubleValue
        return doubleValue.truncatingRemainder(dividingBy: 1) == 0
    }
}
