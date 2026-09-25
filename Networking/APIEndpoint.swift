//
//  APIEndpoint.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 21/09/2026.
//

import Foundation

enum APIEndpoint {
    // MARK: - Auth
    case login(email: String, password: String)
    case register(username: String, email: String, password: String)
    
    // Mark: - Users
    case getMe
    case getUserStats(userId: Int64)
    case searchUsers(query:String)
    
    //MARK: - Activities
    case getActivities
    case createActivity(type: ActivityType, date: String, durationMinutes: Int, distanceKm: Double?, notes: String?)
    case getActivity(id: Int64)
    case updateActivity(id: Int64, type: ActivityType, date: String, durationMinutes: Int, distanceKm: Double?, notes: String?)
    case deleteActivity(id: Int64)
    
    // MARK: - Friends
    case searchFriends(query: String)
    case getFriendRequests
    case sendFriendRequest(userId: Int64)
    case acceptFriendRequest(requestId: Int64)
    case getFriends
    
    // MARK: - Leaderboard & Stats
    case getLeaderboard
    case getStatistics
}

// MARK: - Endpoint Configuration
extension APIEndpoint {
    var baseURL: URL {
        URL(string: "http://localhost:8080")!
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchUsers(let query), .searchFriends(let query):
            return [URLQueryItem(name: "q", value: query)]
        default:
            return nil
        }
    }

    var path: String {
        switch self {
            // Auth
        case .login:
            return "/api/auth/login"
        case .register:
            return "/api/auth/register"
            
            // Users
        case .getMe:
            return "/api/users/me"
        case .getUserStats(let userId):
            return "/api/statistics/\(userId)"
        case .searchUsers:
            return "/api/friends/search"
            
            // Activities
        case .getActivities:
            return "/api/activities"
        case .createActivity:
            return "/api/activities"
        case .getActivity(let id):
            return "/api/activities/\(id)"
        case .updateActivity(let id, _, _, _, _, _):
            return "/api/activities/\(id)"
        case .deleteActivity(let id):
            return "/api/activities/\(id)"
            
            // Friends
        case .searchFriends:
            return "/api/friends/search"
        case .getFriendRequests:
            return "/api/friends/requests"
        case .sendFriendRequest(let userId):
            return "/api/friends/requests/\(userId)"
        case .acceptFriendRequest(let requestId):
            return "/api/friends/requests/\(requestId)/accept"
        case .getFriends:
            return "/api/friends"
            
            // Leaderboard & Stats
        case .getLeaderboard:
            return "/api/leaderboard/weekly"
        case .getStatistics:
            return "/api/statistics"
        }
    }
    
    var method: String {
        switch self {
        case .login, .register, .createActivity, .sendFriendRequest, .acceptFriendRequest:
            return "POST"
        case .updateActivity:
            return "PUT"
        case .deleteActivity:
            return "DELETE"
        default:
            return "GET"
        }
    }
    
    var url: URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.path = path
        components.queryItems = queryItems
        return components.url!
    }
}
