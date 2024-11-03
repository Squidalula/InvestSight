import SwiftUI

struct PortfolioContent: View {
    let portfolio: Portfolio?
    
    var body: some View {
        if let portfolio = portfolio {
            VStack(spacing: 24) {
                // Stocks Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Stocks")
                        .font(.headline)
                        .foregroundColor(Color(hex: "D9D9D9"))
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(portfolio.stocks, id: \.id) { stock in
                            StockRowView(stock: stock)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        } else {
            Text("No portfolio data available")
                .foregroundColor(.gray)
        }
    }
}
