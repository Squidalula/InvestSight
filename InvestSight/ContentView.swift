//
//  ContentView.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: PortfolioViewModel
    @State private var scrollOffset: CGFloat = 0
    
    init(viewModel: PortfolioViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                GeometryReader { geometry in
                    let offset = -geometry.frame(in: .named("scroll")).minY
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: offset
                    )
                }
                .frame(height: 0)
                
                if viewModel.isLoading {
                    ProgressView("Loading portfolio...")
                        .padding()
                } else if let error = viewModel.error {
                    VStack {
                        Text("Error loading portfolio")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task {
                                await viewModel.loadPortfolio()
                            }
                        }
                        .padding()
                    }
                } else {
                    VStack {
                        if let portfolio = viewModel.portfolio {
                            PortfolioGraphView(portfolio: portfolio)
                        }
                        PortfolioContent(portfolio: viewModel.portfolio)
                    }
                    .refreshable {
                        await viewModel.loadPortfolio()
                    }
                }
                
                // Add this temporarily for debugging
                Text("Scroll offset: \(scrollOffset)")
                    .padding()
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                scrollOffset = offset
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Portfolio")
                        .font(.headline)
                }
                ToolbarItem(placement: .principal) {
                    if scrollOffset > 200, let portfolio = viewModel.portfolio {
                        PortfolioHeaderView(portfolio: portfolio)
                            .transition(.opacity)
                            .animation(.easeInOut, value: scrollOffset)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    BrokerStatusView(isConnected: true)
                }
            }
        }
        .task {
            if viewModel.portfolio == nil {
                await viewModel.loadPortfolio()
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    let container = AppContainer()
    return ContentView(viewModel: container.portfolioViewModel)
}
