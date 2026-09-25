//
//  AuthViewModel.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 24/09/2026.
//

import Combine
import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published private(set) var currentUser: User?
    @Published private(set) var isAuthenticated = false
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    
    private let authService: AuthServicing
    
    init(authService: AuthServicing) {
        self.authService = authService
    }
    
    // MARK: - Session bootstrap
    
    func restoreSession() async {
        guard authService.hasStoredToken() else {
            currentUser = nil
            isAuthenticated = false
            return
        }
        
        await loadCurrentUser()
    }
    
    // MARK: - Login
    
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let user = try await authService.login(email: email, password: password)
            currentUser = user
            isAuthenticated = true
        } catch {
            handle(error)
        }
    }
    
    // MARK: - Register
    
    func register(username: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await authService.register(username: username, email: email, password: password)
        } catch {
            handle(error)
        }
    }
    
    // MARK: - Load current user
    
    func loadCurrentUser() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let user = try await authService.fetchCurrentUser()
            currentUser = user
            isAuthenticated = true
        } catch {
            try? authService.logout()
            currentUser = nil
            isAuthenticated = false
            handle(error)
        }
    }
    
    // MARK: - Logout
    
    func logout() {
        do {
            try authService.logout()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        currentUser = nil
        isAuthenticated = false
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Helpers
    
    private func handle(_ error: Error) {
        if let networkError = error as? LocalizedError,
           let description = networkError.errorDescription {
            errorMessage = description
        } else {
            errorMessage = error.localizedDescription
        }
    }
}
