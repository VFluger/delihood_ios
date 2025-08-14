//
//  NetworkManager.swift
//  LoginTestApp
//
//  Created by Vojta Fluger on 12.08.2025.
//

import SwiftUI

enum AuthResult {
    case success
    case needsRegistration(GoogleSignRegisterResponse, token: String)
}

class NetworkManager {
    let baseURL = "https://delihood-backend.onrender.com"
    
    static let shared = NetworkManager()
    
    func getMe() async throws -> User? {
        print("Refreshing user and state")
        let (data, response) = try await NetworkManager.shared.get(path: "/api/me")
        
        guard let _ = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(getUserHelper.self, from: data).data
    }
    
    
    @discardableResult
    func postGoogleToken(token: String) async throws -> AuthResult {
        let data = try await genericPost(path: "/auth/google-sign", body: GoogleSign(token: token), sendJWT: false)
        // If user exists, tokens send, if not, email and name send
        do {
            let tokens = try JSONDecoder().decode(AuthTokens.self, from: data)
            
            if !AuthManager.shared.saveTokens(tokens) {
                throw AuthError.saveTokensFailed
            }
            //SUCCESS
            return .success
            
        }catch {
            print("User not registered, try decode")
            let userData = try JSONDecoder().decode(GoogleSignRegisterResponse.self, from: data)
            print("Decode success")
            //User not registered
            return .needsRegistration(userData, token: token)
        }
        
    }
    
    //MARK: - ConfirmMail and Reset password
    
    func getConfirmMail() async throws {
        try await genericGet(path: "/confirmations/generate-confirm")
    }
    
    func postConfirmMail(token: String) async throws {
        try await genericPost(path: "/confirmations/confirm-mail", body: TokenBody(token: token))
    }
    
    func postPasswordResetMail(email: String) async throws {
        try await genericPost(path: "/auth/generate-password-token", body: PasswordResetMail(email: email), sendJWT: false)
    }
    
    func postNewPassword(password: String, token: String) async throws {
        try await genericPost(path: "/auth/new-password", body: NewPassword(token: token, password: password), sendJWT: false)
    }
    
    
    //MARK: - Helpers, checking if { error: "" } is present
    @discardableResult
    func genericPost<T: Encodable>(path: String, body: T, sendJWT: Bool = true) async throws -> Data {
        let (data, response) = try await NetworkManager.shared.post(path: path, body: body, sendJWT: sendJWT)
        
        guard let _ = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(ErrorStruct.self, from: data)
        
        if let errorMsg = decoded.error, !errorMsg.isEmpty {
            throw GenericError.error(errorMsg)
        } else {
            //SUCCESS
            return data
        }
    }
    
    @discardableResult
    func genericGet(path: String, sendJWT: Bool = true) async throws -> Data {
        let (data, response) = try await NetworkManager.shared.get(path: path, sendJWT: sendJWT)
        
        guard let _ = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(ErrorStruct.self, from: data)
        
        if let errorMsg = decoded.error, !errorMsg.isEmpty {
            throw GenericError.error(errorMsg)
        } else {
            //SUCCESS
            return data
        }
    }
    
    //MARK: - Main Helper get and post, sendJWT decide if auth token included
    func get(path: String, sendJWT: Bool = true, retryCount: Int = 0) async throws -> (Data, URLResponse) {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)

        if sendJWT {
            let accessToken = AuthManager.shared.getAccessToken() ?? ""
            if accessToken.isEmpty {
                // code
                print("Access Token not available")
                throw AuthError.cannotGetToken
            }
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200:
            return (data, response)
        case 401:
            if retryCount < 2 {
                // get new tokens
                try await AuthManager.shared.refreshToken()
                
                // call again
                return try await self.get(path: path, sendJWT: sendJWT, retryCount: retryCount + 1)
            } else {
                throw AuthError.refreshFailed
            }
        case 403:
            throw AuthError.emailNotVerified
        default:
            throw URLError(.badServerResponse)
        }
    }

    func post<T: Encodable>(path: String, body: T, sendJWT: Bool = true, retryCount: Int = 0) async throws -> (Data, URLResponse) {
        
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)

        if sendJWT {
            let accessToken = AuthManager.shared.getAccessToken() ?? ""
            if accessToken.isEmpty {
                // code
                print("Access Token not available")
                throw AuthError.cannotGetToken
            }
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200:
            return (data, response)
        case 401:
            if retryCount < 2 {
                // get new tokens
                try await AuthManager.shared.refreshToken()
                
                // call again
                return try await self.post(path: path, body: body, sendJWT: sendJWT, retryCount: retryCount + 1)
            } else {
                throw AuthError.cannotGetToken
            }
        case 403:
            throw AuthError.emailNotVerified
        default:
            throw URLError(.badServerResponse)
        }
    }
}
