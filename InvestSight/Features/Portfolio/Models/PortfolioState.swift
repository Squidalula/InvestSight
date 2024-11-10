enum PortfolioState: Equatable {
    case idle
    case loading
    case refreshing(Portfolio)
    case loaded(Portfolio)
    case error(Error)
    
    static func == (lhs: PortfolioState, rhs: PortfolioState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.refreshing(let lhsPortfolio), .refreshing(let rhsPortfolio)),
             (.loaded(let lhsPortfolio), .loaded(let rhsPortfolio)):
            return lhsPortfolio == rhsPortfolio
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
