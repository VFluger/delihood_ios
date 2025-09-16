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
            //Success, user is logged in
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
                    //Unknown error or user never logged in, log out
                    appState = .loggedOut
                }
            }
        }
    }
    //not really sync but doesnt need to be awaited
    func syncUpdateState() {
        Task {
            await updateState()
        }
    }
}
