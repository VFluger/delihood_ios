//
//  DeliHoodApp.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.07.2025.
//

import SwiftUI

enum HandledUrlSchemePath: String {
    case resetPassword = "/auth/new-password"
    case confirmMail = "/confirmations/confirm-mail"
}

@main
struct DeliHoodApp: App {
    @StateObject var authState = AuthState()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainScreenView()
                    .environmentObject(authState)
            }
            .onOpenURL { url in
                handleIncomingURL(url)
            }
        }
    }
    
    func handleIncomingURL(_ url: URL) {
        if url.scheme == "delihood" {
            switch url.path {
            case HandledUrlSchemePath.resetPassword.rawValue:
                let token = url.getToken()
                guard token != nil else {
                    //Unknown error
                    return
                }
                authState.resetPasswordToken = token!
                authState.userState = .resetingPassword
                break
            case HandledUrlSchemePath.confirmMail.rawValue:
                authState.userState = .validatingMail
                let token = url.getToken()
                guard token != nil else {
                    authState.userState = .emailNotVerified
                    return
                }
                Task {
                    do {
                        try await NetworkManager.shared.postConfirmMail(token: token ?? "")
                        await authState.updateState()
                    }catch {
                        print(error)
                        authState.userState = .emailNotVerified
                        return
                    }
                }
                break
            default:
                break
            }
        }
    }
    
    
}
