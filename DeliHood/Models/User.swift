//
//  User.swift
//  LoginTestApp
//
//  Created by Vojta Fluger on 12.08.2025.
//

import Foundation

struct getUserHelper: Codable {
    let status: Bool?
    let data: User
}

struct User: Codable {
    let username: String
    let email: String
    let phone: String
    let created_at: String
}
