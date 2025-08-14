//
//  OAuthViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import Foundation

struct GoogleRegistrationData: Hashable {
    let username: String
    let email: String
    let token: String
}

@MainActor
final class OAuthViewModel: ObservableObject {
    @Published var needsRegistrationData: GoogleRegistrationData?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    
    //Returns true if need to update userState
    func signIn(_ funcToLogIn: () async -> AuthResult?) async -> Bool? {
        isLoading = true
            guard let GoogleAuthResult: AuthResult = await funcToLogIn() else {
                isLoading = false
                alertItem = AlertContext.failLogin
                return nil
            }
            
            isLoading = false
            switch GoogleAuthResult {
            case .success:
                return true
            case .needsRegistration(let userData, let token):
                needsRegistrationData = GoogleRegistrationData(username: userData.username, email: userData.email, token: token)
                return false
            }
    }
}
