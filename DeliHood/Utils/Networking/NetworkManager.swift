//
//  NetworkManager.swift
//  LoginTestApp
//
//  Created by Vojta Fluger on 12.08.2025.
//

import SwiftUI

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

class NetworkManager {
    let baseURL = "http://localhost:8080"
    
    static let shared = NetworkManager()
    
    func getMe() async throws -> User? {
        let (data, response) = try await NetworkManager.shared.get(path: "/api/me")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        print(httpResponse.statusCode)
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(getUserHelper.self, from: data).data
        case 401:
            // get new tokens
            try await AuthManager.shared.refreshToken()
            
            // call again
            let retriedUser = try await self.getMe()
                if retriedUser == nil {
                    throw AuthError.networkError(description: "Cannot get new token")
                }
                return retriedUser
        case 403:
            throw AuthError.emailNotVerified
        default:
            throw URLError(.badServerResponse)
        }
    }

    
    func getConfirmMail() async throws {
        let (data, response) = try await NetworkManager.shared.get(path: "/confirmations/generate-confirm")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(ErrorStruct.self, from: data)
        
        if let errorMsg = decoded.error, !errorMsg.isEmpty {
            throw GenericError.error(errorMsg)
        } else {
            print("✅ Confirmation mail sended")
            
        }
    }
    
    func postConfirmMail(token: String) async throws {
        let (data, response) = try await NetworkManager.shared.post(path: "/confirmations/confirm-mail", body: TokenBody(token: token))
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(ErrorStruct.self, from: data)
        
        if let errorMsg = decoded.error, !errorMsg.isEmpty {
            throw GenericError.error(errorMsg)
        } else {
            //SUCCESS
            return
        }
    }
    
    func postPasswordResetMail(email: String) async throws {
        let (data, response) = try await NetworkManager.shared.postWithoutToken(path: "/auth/generate-password-token", body: PasswordResetMail(email: email))
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(ErrorStruct.self, from: data)
        
        if let errorMsg = decoded.error, !errorMsg.isEmpty {
            throw GenericError.error(errorMsg)
        } else {
            //SUCCESS
            return
        }
    }
    
    func postNewPassword(password: String, token: String) async throws {
        let (data, response) = try await NetworkManager.shared.postWithoutToken(path: "/auth/new-password", body: NewPassword(token: token, password: password))
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(ErrorStruct.self, from: data)
        
        if let errorMsg = decoded.error, !errorMsg.isEmpty {
            throw GenericError.error(errorMsg)
        } else {
            //SUCCESS
            return
        }
    }
    
    func get(path: String) async throws -> (Data, URLResponse) {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        let accessToken = AuthManager.shared.getAccessToken() ?? ""
        if accessToken.isEmpty {
            // code
            throw AuthError.cannotGetToken
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        switch httpResponse.statusCode {
        case 200:
            return (data, response)
        case 401:
            // get new tokens
            try await AuthManager.shared.refreshToken()
            
            // call again
            return try await self.get(path: path)
        case 403:
            throw AuthError.emailNotVerified
        default:
            throw URLError(.badServerResponse)
        }
    }
    
    func getWithoutToken(path: String) async throws -> (Data, URLResponse) {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try await URLSession.shared.data(for: request)
    }

    func post<T: Encodable>(path: String, body: T) async throws -> (Data, URLResponse) {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        let accessToken = AuthManager.shared.getAccessToken() ?? ""
        if accessToken.isEmpty {
            // code
            throw AuthError.cannotGetToken
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            throw error
        }
        return try await URLSession.shared.data(for: request)
        
    }
    func postWithoutToken<T: Encodable>(path: String, body: T) async throws -> (Data, URLResponse) {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            throw error
        }
        return try await URLSession.shared.data(for: request)
        
    }
}
