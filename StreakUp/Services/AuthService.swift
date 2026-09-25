//
//  AuthService.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 25/09/2026.
//

import Foundation

protocol AuthServicing {
    func hasStoredToken() -> Bool
    func login(email: String, password: String) async throws -> User
    func register(username: String, email: String, password: String) async throws
    func fetchCurrentUser() async throws -> User
    func logout() throws
}

final class AuthService: AuthServicing {
    private let apiClient: APIClient
    private let keychain: KeychainService
    
    init(apiClient: APIClient = .shared, keychain: KeychainService = .shared) {
        self.apiClient = apiClient
        self.keychain = keychain
    }
    
    func hasStoredToken() -> Bool {
        keychain.getToken() != nil
    }
    
    func login(email: String, password: String) async throws -> User {
        let response: AuthResponse = try await apiClient.request(endpoint: .login(email: email, password: password), responseType: AuthResponse.self)
        try keychain.saveToken(response.token)
        return response.user
    }
    
    func register(username: String, email: String, password: String) async throws {
        let _: User = try await apiClient.request(endpoint: .register(username: username, email: email, password: password), responseType: User.self)
    }
    
    func fetchCurrentUser() async throws -> User {
        try await apiClient.request(endpoint: .getMe, responseType: User.self)
    }
    
    func logout() throws {
        try keychain.deleteToken()
    }
}
