//
//  Friend.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 13/09/2026.
//
import Foundation
struct Friend: Identifiable, Codable {
    let id: UUID
    let username: String
    // no status needed here at all if it's in this list, it's already ACCEPTED
}
