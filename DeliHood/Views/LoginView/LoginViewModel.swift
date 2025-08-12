//
//  LoginViewModel.swift
//  LoginTestApp
//
//  Created by Vojta Fluger on 12.08.2025.
//
import Foundation
import SwiftUI
import GoogleSignIn

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isEmailValid = true
    @Published var isPasswordValid = true
    
    @Published var alertItem: AlertItem?
    @Published var isForgottenSheetPresented = false
    
    var canProceed: Bool {
        Validator.validateEmail(email) && Validator.validatePassword(password)
    }
    
    func loginUser() {
        Task {
            do {
                try await AuthManager.shared.login(email: email, password: password)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                //SUCESS: LOGGED IN
                print("logged in")
                
            } catch let authError as AuthError {
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                switch authError {
                case .wrongPassOrMail:
                    alertItem = AlertContext.wrongPassOrMail
                
                case .networkError(_):
                    alertItem = AlertContext.networkFail
                
                default:
                    alertItem = AlertContext.failLogin
                }
            } catch {
                alertItem = AlertContext.failLogin
            }
        }
    }
    
    func googleSign() {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        // Get a proper UIViewController for presenting
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        // Present Google Sign-In
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            let idToken = user.idToken?.tokenString ?? ""
            let accessToken = user.accessToken.tokenString
            print("Google Sign-In success. ID Token: \(idToken), Access Token: \(accessToken)")
            // Send tokens to backend or proceed in app
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            
        }
    }
}
