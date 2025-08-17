//
//  DeliHoodApp.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.07.2025.
//

import SwiftUI
import SwiftData

enum HandledUrlSchemePath: String {
    case resetPassword = "/auth/new-password"
    case confirmMail = "/confirmations/confirm-mail"
}

@main
struct DeliHoodApp: App {
    @StateObject var authStore = AuthStore()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainScreenView()
                    .environmentObject(authStore)
            }
            .onOpenURL { url in
                handleIncomingURL(url)
            }
            .modelContainer(for: Location.self)
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
                authStore.resetPasswordToken = token!
                authStore.appState = .resetingPassword
                break
            case HandledUrlSchemePath.confirmMail.rawValue:
                authStore.appState = .validatingMail
                let token = url.getToken()
                guard token != nil else {
                    authStore.appState = .emailNotVerified
                    return
                }
                Task {
                    do {
                        try await NetworkManager.shared.postConfirmMail(token: token ?? "")
                        await authStore.updateState()
                    }catch {
                        print(error)
                        authStore.appState = .emailNotVerified
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
