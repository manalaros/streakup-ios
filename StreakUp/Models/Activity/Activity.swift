//
//  Activity.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 13/09/2026.
//

import Foundation
struct Activity: Identifiable, Codable {
    let id: Int64
    let userId: Int64
    let username: String
    let type: ActivityType
    var date: String
    var durationMinutes: Int
    let distanceKm: Double?
    var notes: String?
    let createdAt: Date
}
