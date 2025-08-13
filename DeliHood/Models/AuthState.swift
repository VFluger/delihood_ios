//
//  AuthState.swift
//  DeliHood
//
//  Created by Vojta Fluger on 12.08.2025.
//

import Foundation

enum UserState {
    case loading
    case emailNotVerified
    case validatingMail
    case resetingPassword
    case loggedIn
    case loggedOut
}

@MainActor
class AuthState: ObservableObject {
    @Published var userState: UserState = .loading
    @Published var user: User?
    @Published var resetPasswordToken: String?
    
    init() {
        Task{
            await updateState()
        }
    }
    func updateState() async {
            do {
                user = try await NetworkManager.shared.getMe()
                userState = .loggedIn
            } catch {
                print(error)
                switch error {
                case AuthError.emailNotVerified:
                    userState = .emailNotVerified
                default:
                    userState = .loggedOut
                }
            }
    }
}
