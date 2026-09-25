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
    @Published private(set) var isAuthenticated: Bool = false
    @Published private(set) var authToken: String?
    
    // MARK: - Session bootstrap
    
    func restoreSession() async {
        guard KeychainService.shared.getToken() != nil else {
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
            let response: AuthResponse = try await APIClient.shared.request(endpoint: .login(email: email, password: password), responseType: AuthResponse.self)
            try KeychainService.shared.saveToken(response.token)
            currentUser = response.user
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
            let _: User = try await APIClient.shared.request(endpoint: .register(username: username, email: email, password: password),
                                                             responseType: User.self)
            // Registration succeded.
            // In the UI later, this can trigger navigation back to login.
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
            let user: User = try await APIClient.shared.request(endpoint: .getMe(), responseType: User.self)
            currentUser = user
            isAuthenticated = true
        } catch {
            try?
            KeychainService.shared.deleteToken()
            currentUser = nil
            isAuthenticated = false
            handle(error)
        }
    }
    
    // MARK: - Logout
    
    func logout() {
        do {
            try KeychainService.shared.deleteToken()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        currentUser = nil
        isAuthenticated = false
    }
    
    // MARK: - Helpers
    
    func clearError() {
        errorMessage = nil
    }
    
    private func handle(_ error: Error) {
        if let networkError = error as? LocalizedError,
           let description = networkError.errorDescription {
            errorMessage = description
        } else {
            errorMessage = error.localizedDescription
        }
    }
}
    
