//
//  AuthStore.swift
//  DeliHood
//
//  Created by Vojta Fluger on 12.08.2025.
//

import Foundation
import SwiftUI

//Main appstate to show different views
enum AppState {
    case loading
    case noConnection
    
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
    
    //When app opened, updateState
    init() {
        Task{
            await updateState()
        }
    }
    
    func updateState() async {
        do {
            //Try to get user info
            user = try await NetworkManager.shared.getMe()
            //Success, logged in
            withAnimation(.easeOut) {
                appState = .loggedIn
            }
        } catch {
            //Check if no connection
            if let urlError = error as? URLError {
                if urlError.code == .notConnectedToInternet {
                    appState = .noConnection
                    return
                }
            }
            withAnimation(.easeOut) {
                switch error {
                    //If email not verified, update state
                case MainError.emailNotVerified:
                    appState = .emailNotVerified
                default:
                    //Unknown error, log out
                    appState = .loggedOut
                }
            }
        }
    }
    //If needed for whatever reason
    func syncUpdateState() {
        Task {
            await self.updateState()
        }
    }
}
