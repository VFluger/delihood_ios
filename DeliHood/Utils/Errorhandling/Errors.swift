//
//  Errors Handling.swift
//  LoginTestApp
//
//  Created by Vojta Fluger on 12.08.2025.
//

import SwiftUI

enum MainError: Error {
    case cannotDecode
    case cannotGetToken
    case networkError(description: String)
    case invalidResponse
    case saveTokensFailed
    case wrongPassOrMail
    case userAlreadyInDb
    case emailNotVerified
    case refreshFailed
    case duplicateValue
    case notFound
}

enum GenericError: Error {
    case error(String)
}

