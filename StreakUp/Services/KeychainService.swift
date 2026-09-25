//
//  KeychainService.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 21/09/2026.
//

import Foundation
import Security

class KeychainService {
    static let shared = KeychainService()
    
    private let serviceName = "com.streakup.app"
    private let tokenKey = "authToken"
    
    // MARK: - Save Token
    func saveToken(_ token: String) throws {
        let data = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data
        ]
        
        // Delete any existing token first
        SecItemDelete(query as CFDictionary)
        
        // Add the new token
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.failedToSave(status)
        }
    }
    
    // MARK: - Retrieve Token
    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }
    
    // MARK: - Delete Token (logout
    func deleteToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: tokenKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.failedToDelete(status)
        }
    }
}

// MARK: - Keychain Errors
enum KeychainError: LocalizedError {
    case failedToSave(OSStatus)
    case failedToDelete(OSStatus)
    case failedToRetrieve
    
    var errorDescription: String? {
        switch self {
        case .failedToSave(let status):
            return "Failed to save token to Keychain. Status: \(status)"
        case .failedToDelete(let status):
            return "Failed to delete token from Keychain. Status: \(status)"
        case .failedToRetrieve:
            return "Failed to retrieve token from Keychain."
        }
        
    }
}
