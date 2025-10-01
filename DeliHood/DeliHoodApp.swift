//
//  DeliHoodApp.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.07.2025.
//

import SwiftUI
import SwiftData
import Stripe

//delihood:// url handling
enum HandledUrlSchemePath: String {
    case resetPassword = "/auth/new-password"
    case confirmMail = "/confirmations/confirm-mail"
}

@main
struct DeliHoodApp: App {
    @StateObject var authStore = AuthStore()
    @StateObject var orderStore = OrderStore()
    @StateObject var paymentManager = PaymentSheetManager()
 
    //Init with stripe publishableKey
    init() {
            StripeAPI.defaultPublishableKey = "pk_test_51RsJbVCG0zW7ss1SthneT3YrP5Ru3wxNiMfv3NKNgXnP62IyuN73mhEGuernZI0kqJ2owNxRbVRdiBOhGFZpPxk900T1A8rqZ9"
        }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainScreenView()
                    .modelContainer(for: Location.self)
                    .environmentObject(authStore)
                    .environmentObject(orderStore)
                    .environmentObject(paymentManager)
            }
            
            .onOpenURL { url in
                handleIncomingURL(url)
            }
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
