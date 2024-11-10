import SwiftUI

struct PortfolioHeaderView: View {
    let portfolio: Portfolio
    
    var body: some View {
        HStack(spacing: 4) {
            Text("€")
                .font(.headline)
            Text("\(portfolio.totalValue.formatted())")
                .font(.headline)
        }
        .padding(.horizontal)
    }
}
