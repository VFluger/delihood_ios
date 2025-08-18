//
//  DeliHoodApp.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.07.2025.
//

import SwiftUI
import SwiftData

//delihood:// url handling
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
                
            //Reset password path
            case HandledUrlSchemePath.resetPassword.rawValue:
                // Check token
                let token = url.getToken()
                guard let token = token else {
                    //Unknown error
                    return
                }
                authStore.resetPasswordToken = token
                //User sets new password
                authStore.appState = .resetingPassword
                break
            
            //Verify email address path
            case HandledUrlSchemePath.confirmMail.rawValue:
                authStore.appState = .validatingMail
                //Get token and check if ok
                let token = url.getToken()
                guard token != nil else {
                    authStore.appState = .emailNotVerified
                    return
                }
                //Post confirm
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
                // Not known url
                break
            }
        }
    }
    
    
}
