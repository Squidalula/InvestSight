import SwiftUI

struct PortfolioMainView: View {
    let state: PortfolioState
    let shouldHideValue: Bool
    let retryAction: () -> Void
    let historyService: PortfolioHistoryService
    
    var body: some View {
        VStack {
            switch state {
            case .idle, .loading:
                ProgressView()
                    .padding()
            case .refreshing(let portfolio), .loaded(let portfolio):
                PortfolioGraphView(
                    portfolio: portfolio,
                    historyService: historyService
                )
                .opacity(shouldHideValue ? 0 : 1)
                .offset(y: shouldHideValue ? -20 : 0)
                .animation(.easeInOut(duration: 0.3), value: shouldHideValue)
                
                PortfolioContent(portfolio: portfolio)
                    .animation(.easeInOut, value: portfolio)
            case .error(let error):
                ErrorView(error: error, retryAction: retryAction)
            }
        }
    }
}