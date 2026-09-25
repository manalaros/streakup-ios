//
//  ApiError.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 21/09/2026.
//

import Foundation

struct ApiError: Codable {
    let timestamp: Date
    let status: Int
    let error: String
    let message: String
    let path: String
    let fields: [String: String]
}
