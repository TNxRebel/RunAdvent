//
//  RunventApp.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import SwiftUI

@main
struct RunventApp: App {
    @StateObject private var viewModel = RunventViewModel()
    
    init() {
        // Initialize settings manager to load saved preferences
        _ = SettingsManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(viewModel)
        }
    }
}
