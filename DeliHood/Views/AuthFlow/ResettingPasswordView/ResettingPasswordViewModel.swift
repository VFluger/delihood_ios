//
//  ResettingPasswordViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

@MainActor
final class ResettingPasswordViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isPasswordValid = true
    @Published var isConfirmPasswordValid = true
    
    @Published var alertItem: AlertItem?
    
    var isBtnDisabled: Bool {
        !(isPasswordValid && isConfirmPasswordValid)
    }
    
    func resetPassword(token: String) {
        Task {
            do {
                try await NetworkManager.shared.postNewPassword(password: password, token: token)
                alertItem = AlertContext.resetPassSuccess
                
            }catch {
                print(error)
                alertItem = AlertContext.resetPassFail
            }
        }
    }
}
