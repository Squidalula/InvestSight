import SwiftUI
import Charts

struct PortfolioGraphView: View {
    let portfolio: Portfolio
    @StateObject private var viewModel: PortfolioGraphViewModel
    
    init(portfolio: Portfolio, historyService: PortfolioHistoryService) {
        self.portfolio = portfolio
        _viewModel = StateObject(wrappedValue: PortfolioGraphViewModel(
            portfolioHistoryService: historyService,
            portfolio: portfolio
        ))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Portfolio Value Section
            portfolioValueSection
            
            // Graph Section
            graphSection
            
            // Time Range Selector
            timeRangeSelector
                .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .task {
            await viewModel.loadHistory()
        }
    }
    
    private var portfolioValueSection: some View {
        VStack(spacing: 8) {
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
    }
    
    private var timeRangeSelector: some View {
        HStack(spacing: 12) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button {
                    viewModel.selectedTimeRange = range
                    Task {
                        await viewModel.loadHistory()
                    }
                } label: {
                    Text(range.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(viewModel.selectedTimeRange == range ? .white : .gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Group {
                                if viewModel.selectedTimeRange == range {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray5))
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
    
    private var graphSection: some View {
        Chart(viewModel.entries, id: \.timestamp) { entry in
            LineMark(
                x: .value("Time", entry.timestamp),
                y: .value("Value", entry.totalValue)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(
                LinearGradient(
                    colors: [Color(hex: "D1FEA0"), Color(hex: "A0F8FA")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        }
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks { value in
                if let yValue = value.as(Decimal.self) {
                    AxisValueLabel {
                        let formatted = formatAxisValue(yValue)
                        Text("€\(formatted)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(height: 150)
        .padding(.horizontal)
    }
    
    private var timeFormatter: Date.FormatStyle {
        switch viewModel.selectedTimeRange {
        case .day:
            return .dateTime.hour()
        case .week:
            return .dateTime.weekday()
        case .month:
            return .dateTime.day()
        case .year:
            return .dateTime.month()
        case .all:
            return .dateTime.year()
        }
    }
    
    private func formatAxisValue(_ value: Decimal) -> String {
        let number = NSDecimalNumber(decimal: value)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        
        if value >= 1000000 {
            return "\(formatter.string(from: NSDecimalNumber(decimal: value / 1000000)) ?? "0")M"
        } else if value >= 1000 {
            return "\(formatter.string(from: NSDecimalNumber(decimal: value / 1000)) ?? "0")k"
        }
        
        return formatter.string(from: number) ?? "0"
    }
}

struct PortfolioGraphView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewGraphWrapper()
    }
}

private struct PreviewGraphWrapper: View {
    let portfolio = PreviewData.mockPortfolio
    let historyService = PreviewData.mockHistoryService
    
    var body: some View {
        PortfolioGraphView(
            portfolio: portfolio,
            historyService: historyService
        )
        .frame(height: 400)
        .padding()
    }
}
