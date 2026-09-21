//
//  UserRegistrationRequest.swift
//  StreakUp
//
//  Created by Manal Aros El Morabet on 21/09/2026.
//

import Foundation

struct UserRegistrationRequest: Codable {
    let username: String
    let email: String
    let password: String
}
