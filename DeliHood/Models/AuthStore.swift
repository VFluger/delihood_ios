//
//  AuthState.swift
//  DeliHood
//
//  Created by Vojta Fluger on 12.08.2025.
//

import Foundation
import SwiftUI

enum AppState {
    case loading
    case emailNotVerified
    case validatingMail
    case resetingPassword
    case loggedIn
    case loggedOut
}

@MainActor
class AuthStore: ObservableObject {
    @Published var appState: AppState = .loading
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
                withAnimation(.easeOut) {
                    appState = .loggedIn
                }
            } catch {
                print(error)
                withAnimation(.easeOut) {
                    switch error {
                    case AuthError.emailNotVerified:
                        appState = .emailNotVerified
                    default:
                        appState = .loggedOut
                    }
                }
            }
    }
}
