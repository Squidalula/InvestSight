import SwiftUI
import Charts

struct PortfolioGraphView: View {
    let portfolio: Portfolio
    
    var body: some View {
        VStack(spacing: 0) {
            // Portfolio Value Section
            VStack(spacing: 8) {
                Text("Portfolio")
                    .font(.headline)
                    .foregroundColor(Color(hex: "D9D9D9"))
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(portfolio.totalValue.formatted())")
                        .font(.system(size: 34, weight: .bold))
                    Text("€")
                        .font(.title2)
                        .bold()
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "arrow.up.right")
                        .rotationEffect(.degrees(portfolio.unrealizedProfitLoss >= 0 ? 0 : 180))
                    Text("€\(abs(portfolio.unrealizedProfitLoss).formatted())")
                    Text("(\(portfolio.unrealizedPLPercentage.formatted(.number.precision(.fractionLength(2))))%)")
                }
                .foregroundColor(portfolio.unrealizedProfitLoss >= 0 ? Color(hex: "34A853") : Color(hex: "FF5A5F"))
            }
            .padding(.bottom, 24)
            
            // Graph Section
            GeometryReader { geometry in
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height))
                    path.addCurve(
                        to: CGPoint(x: geometry.size.width, y: geometry.size.height * 0.2),
                        control1: CGPoint(x: geometry.size.width * 0.3, y: geometry.size.height * 0.8),
                        control2: CGPoint(x: geometry.size.width * 0.7, y: geometry.size.height * 0.4)
                    )
                }
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "D1FEA0"), Color(hex: "A0F8FA")],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
            }
            .frame(height: 100)
            .padding(.horizontal)
        }
        .padding(.vertical, 16)
    }
}
