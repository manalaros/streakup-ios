//
//  ActivityRequest.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 21/09/2026.
//

import Foundation

struct ActivityRequest: Codable {
    let type: ActivityType
    let date: String
    let durationMinutes: Int
    let distance: Double?
    let notes: String?
}
