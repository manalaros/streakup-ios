//
//  AuthResponse.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 21/09/2026.
//
import Foundation

struct AuthResponse: Codable {
    let token: String
    let user: User
}
