//
//  StatisticsResponse.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 21/09/2026.
//

import Foundation

struct StatisticsResponse: Codable {
    let userId: Int64
    let username: String
    let currentStreak: Int64
    let longestStreak: Int64
    let totalActivities: Int64
    let totalDurationMinutes: Int64
    let weeklyActivities: Int64
    let weeklyDurationMinutes: Int64
}
