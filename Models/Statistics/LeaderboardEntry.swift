//
//  LeaderboardEntry.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 21/09/2026.
//


import Foundation

struct LeaderboardEntry: Codable {
    let rank: Int
    let userId: Int64
    let username: String
    let activities: Int64
    let durationMinutes: Int64
}
