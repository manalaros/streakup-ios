//
//  APIClient.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 21/09/2026.
//

import Foundation

final class APIClient {
    
    static let shared = APIClient()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    // MARK: - Initialization
    
    init() {
        // Configure decoder to handle ISO 8601 dates
        decoder.dateDecodingStrategy = .iso8601
        encoder.dateEncodingStrategy = .iso8601
    }
    
    // MARK: - Generic request method
    func request<T: Codable>(endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        let (data, httpResponse) = try await performRequest(endpoint: endpoint)

        guard (200...299).contains(httpResponse.statusCode) else {
            throw try decodeServerError(from: data, fallbackStatusCode: httpResponse.statusCode)
        }

        guard !data.isEmpty else {
            throw NetworkError.emptyResponse
        }

        do {
            return try decoder.decode(responseType, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    // MARK: - Void request method
    func requestVoid(endpoint: APIEndpoint) async throws {
        let (data, httpResponse) = try await performRequest(endpoint: endpoint)

        guard (200...299).contains(httpResponse.statusCode) else {
            throw try decodeServerError(from: data, fallbackStatusCode: httpResponse.statusCode)
        }
    }
    
    // MARK: - Request builder
    private func performRequest(endpoint: APIEndpoint) async throws -> (Data, HTTPURLResponse) {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.httpMethod = endpoint.method

        if let token = KeychainService.shared.getToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body = try encodeRequestBody(for: endpoint) {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = body
        }

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        return (data, httpResponse)
    }

    private func decodeServerError(from data: Data, fallbackStatusCode: Int) throws -> NetworkError {
        if let apiError = try? decoder.decode(ApiError.self, from: data) {
            return .serverError(apiError)
        }
        return .httpError(fallbackStatusCode)
    }

    // MARK: - Helper: encode request body
    private func encodeRequestBody(for endpoint: APIEndpoint) throws -> Data? {
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
            return nil
        }
    }
}

// MARK: - Network Errors
enum NetworkError: LocalizedError {
    case invalidResponse
    case httpError(Int)
    case serverError(ApiError)
    case decodingError(Error)
    case emptyResponse
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
        case .emptyResponse:
            return "The server returned no data."
        case .keychainError(let error):
            return error.localizedDescription
        }
    }
}
