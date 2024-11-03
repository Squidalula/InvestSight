//
//  InvestSightApp.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import SwiftUI
import BackgroundTasks

@main
@MainActor
struct InvestSightApp: App {
    private let container = AppContainer()
    
    init() {
        // Configure background tasks
        configureBackgroundTasks()
    }
    
    private func configureBackgroundTasks() {
        let backgroundIdentifier = "com.investsight.portfoliorefresh"
        
        do {
            try BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundIdentifier, using: nil) { task in
                Task {
                    await self.container.backgroundTaskService.handleBackgroundRefresh(task: task as! BGAppRefreshTask)
                }
            }
            
            // Schedule the first background task asynchronously
            Task {
                await self.container.backgroundTaskService.scheduleNextRefresh()
            }
        } catch {
            print("Could not register background task: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: container.portfolioViewModel,
                historyService: container.portfolioHistoryService
            )
        }
    }
}
