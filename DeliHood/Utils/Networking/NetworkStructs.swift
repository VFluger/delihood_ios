//
//  NetworkStructs.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let phone: String
    let username: String
}

struct RegisterResponse: Codable {
    let success: Bool?
    let error: String?
}

struct AuthTokens: Codable {
    let accessToken: String
    let refreshToken: String
}

struct ErrorStruct: Codable {
    let error: String?
}

struct TokenBody: Encodable {
    let token: String
}

struct PasswordResetMail: Encodable {
    let email: String
}

struct NewPassword: Encodable {
    let token: String
    let password: String
}
