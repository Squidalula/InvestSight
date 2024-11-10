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
    @State private var showingSettings = false
    private let historyService: PortfolioHistoryService
    
    init(viewModel: PortfolioViewModel, historyService: PortfolioHistoryService) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.historyService = historyService
    }
    
    var shouldShowNavValue: Bool {
        scrollOffset < -150 // Adjust this threshold as needed
    }
    
    var body: some View {
        NavigationView {
            RefreshableView {
                // Partial refresh on pull-to-refresh
                await viewModel.refresh(includeCache: false)
            } content: {
                PortfolioMainView(
                    state: viewModel.state,
                    shouldHideValue: shouldShowNavValue,
                    retryAction: { 
                        Task { 
                            // Full refresh on error retry
                            await viewModel.refresh(includeCache: true)
                        } 
                    },
                    historyService: historyService
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                PortfolioToolbar(
                    showSettings: $showingSettings
                )
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .presentationDetents([.medium])
        }
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
            withAnimation(.easeInOut(duration: 0.3)) {
                scrollOffset = offset
            }
        }
        .task {
            if case .idle = viewModel.state {
                // Full refresh on initial load
                await viewModel.refresh(includeCache: true)
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
    return ContentView(viewModel: container.portfolioViewModel, historyService: container.portfolioHistoryService)
}
