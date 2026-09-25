//
//  User.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 13/09/2026.
//
import Foundation

struct User: Identifiable, Codable {
    let id: Int64
    let username: String
    let email: String
    let createdAt: Date
}


