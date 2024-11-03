//
//  InvestSightApp.swift
//  InvestSight
//
//  Created by Tiago Afonso on 02/11/2024.
//

import SwiftUI

@main
struct InvestSightApp: App {
    @StateObject private var container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: container.portfolioViewModel)
        }
    }
}
