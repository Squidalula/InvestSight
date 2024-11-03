import Foundation

@MainActor
final class PortfolioViewModel: ObservableObject {
    private let trading212Service: Trading212ServiceProtocol
    private var currentTask: Task<Void, Never>?
    
    @Published private(set) var portfolio: Portfolio?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    init(trading212Service: Trading212ServiceProtocol) {
        self.trading212Service = trading212Service
    }
    
    func loadPortfolio() async {
        // Cancel any existing task
        currentTask?.cancel()
        
        currentTask = Task {
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                isLoading = true
                error = nil
            }
            
            do {
                let t212Portfolio = try await trading212Service.fetchPortfolio()
                guard !Task.isCancelled else { return }
                
                let t212Stocks = try await trading212Service.fetchStocks()
                guard !Task.isCancelled else { return }
                
                let stocks = t212Stocks.map { $0.toDomain() }
                let domainPortfolio = t212Portfolio.toDomain(with: stocks)
                
                await MainActor.run {
                    self.portfolio = domainPortfolio
                    self.isLoading = false
                    self.error = nil
                }
            } catch {
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
        
        await currentTask?.value
    }
} 