//
//  ContentView.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: PortfolioViewModel
    @State private var scrollOffset: CGFloat = 0
    @State private var showingSettings = false
    private let historyService: PortfolioHistoryService
    
    init(viewModel: PortfolioViewModel, historyService: PortfolioHistoryService) {
        self.viewModel = viewModel
        self.historyService = historyService
    }
    
    var shouldShowNavValue: Bool {
        scrollOffset < -150
    }
    
    var body: some View {
        NavigationView {
            RefreshableView {
                await viewModel.refresh(includeCache: false)
            } content: {
                PortfolioMainView(
                    state: viewModel.state,
                    shouldHideValue: shouldShowNavValue,
                    retryAction: { 
                        Task { 
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
                await viewModel.refresh(includeCache: true)
            }
        }
    }
}

#Preview {
    let container = AppContainer()
    return ContentView(viewModel: container.portfolioViewModel, historyService: container.portfolioHistoryService)
}
