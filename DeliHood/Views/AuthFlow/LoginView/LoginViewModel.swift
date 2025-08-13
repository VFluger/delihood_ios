//
//  LoginViewModel.swift
//  LoginTestApp
//
//  Created by Vojta Fluger on 12.08.2025.
//
import Foundation
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject, OAuthVMProtocol {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isEmailValid = true
    @Published var isPasswordValid = true
    
    @Published var alertItem: AlertItem?
    @Published var isForgottenSheetPresented = false
    
    var canProceed: Bool {
        Validator.validateEmail(email) && Validator.validatePassword(password)
    }
    
    func loginUser() async {
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
