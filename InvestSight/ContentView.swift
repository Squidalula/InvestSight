//
//  ContentView.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: PortfolioViewModel
    
    init(viewModel: PortfolioViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                Text("Loading portfolio...")
            } else if let portfolio = viewModel.portfolio {
                Text("Portfolio Value")
                    .font(.headline)
                Text("€\(portfolio.totalValue.formatted())")
                    .font(.title)
                    .bold()
                
                if portfolio.unrealizedProfitLoss >= 0 {
                    Text("+€\(portfolio.unrealizedProfitLoss.formatted())")
                        .foregroundColor(.green)
                } else {
                    Text("-€\(abs(portfolio.unrealizedProfitLoss).formatted())")
                        .foregroundColor(.red)
                }
            } else if let error = viewModel.error {
                VStack(spacing: 10) {
                    Text("Error loading portfolio")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                }
            } else {
                Text("No portfolio data available")
            }
        }
        .padding()
        .task {
            await viewModel.loadPortfolio()
        }
    }
}

#Preview {
    let container = AppContainer()
    return ContentView(viewModel: container.portfolioViewModel)
}
