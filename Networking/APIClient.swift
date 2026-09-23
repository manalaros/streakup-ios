//
//  APIClient.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 21/09/2026.
//

import Foundation

class APIClient {
    
    static let shared = APIClient()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    // MARK: - Initialization
    
    init() {
        // Configure decoder to handle ISO 8601 dates
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Generic request method
    func request<T: Codable>(endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.httpMethod = endpoint.method
        
        // Add JWT token if it exists
        if let token = KeychainService.shared.getToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Set content type
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add request body for POST/PUT
        if endpoint.method != "GET" && endpoint.method != "DELETE" {
            urlRequest.httpBody = try encodeRequestBody(for: endpoint)
        }
        
        // Make the request
        let (data, response) = try await session.data(for: urlRequest)
        
        // Check for HTTP errors
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Handle non-200 status codes
        guard (200...299).contains(httpResponse.statusCode) else {
            // Try to decode the error response
            if let apiError = try? decoder.decode(ApiError.self, from: data) {
                throw NetworkError.serverError(apiError)
            } else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
        }
        
        // Decode the response
        do{
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Helper: encode request body
    private func encodeRequestBody(for endpoint: APIEndpoint) throws -> Data {
        switch endpoint {
        case .login(let email, let password):
            let request = LoginRequest(email: email, password: password)
            return try encoder.encode(request)
        
        case .register(let username, let email, let password):
            let request = UserRegistrationRequest(username: username, email: email, password: password)
            return try encoder.encode(request)
            
        case .createActivity(let type, let date, let durationMinutes, let distanceKm, let notes):
            let request = ActivityRequest(type: type, date: date, durationMinutes: durationMinutes, distanceKm: distanceKm, notes: notes)
            return try encoder.encode(request)
            
        case .updateActivity(_, let type, let date, let durationMinutes, let distanceKm, let notes):
            let request = ActivityRequest(type: type, date: date, durationMinutes: durationMinutes, distanceKm: distanceKm, notes: notes)
            return try encoder.encode(request)
            
        case .sendFriendRequest(let userId):
            let request = FriendRequest(userId: userId)
            return try encoder.encode(request)
        
        default:
            return Data()
        }
    }
}

// MARK: - Network Errors
enum NetworkError: LocalizedError {
    case invalidResponse
    case httpError(Int)
    case serverError(ApiError)
    case decodingError(Error)
    case keychainError(KeychainError)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP \(statusCode) error"
        case .serverError(let apiError):
            return apiError.message
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .keychainError(let error):
            return error.localizedDescription
        }
    }
}
