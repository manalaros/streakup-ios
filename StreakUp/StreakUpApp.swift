//
//  StreakUpApp.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 13/09/2026.
//

import SwiftUI

@main
struct StreakUpApp: App {
    @StateObject private var authViewModel: AuthViewModel
    
    init() {
        let authService = AuthService()
        _authViewModel = StateObject(wrappedValue: AuthViewModel(authService: authService))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .task {
                    await authViewModel.restoreSession()
                }
        }
    }
}
