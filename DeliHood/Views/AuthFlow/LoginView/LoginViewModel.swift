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
    @Published var hasNoConnection = false
    @Published var isForgottenSheetPresented = false
    
    var canProceed: Bool {
        Validator.validateEmail(email) && Validator.validatePassword(password)
    }
    
    func loginUser() async {
            do {
                try await AuthManager.shared.login(email: email, password: password)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                //SUCESS: LOGGED IN
                
            }catch {
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    hasNoConnection = true
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                    switch error {
                    case MainError.networkError(_):
                        alertItem = AlertContext.networkFail
                    case MainError.wrongPassOrMail:
                        alertItem = AlertContext.wrongPassOrMail
                    default:
                        alertItem = AlertContext.failLogin
                    }
                }
            }
    }
}
