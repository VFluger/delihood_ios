//
//  ForgottenPasswordViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

@MainActor
final class ForgottenPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    
    @Published var alertItem: AlertItem? = nil
    
    func submit() {
        Task {
            do {
                try await NetworkManager.shared.postPasswordResetMail(email: email)
                alertItem = AlertContext.forgottenPasswordSend
            }catch {
                print(error)
            }
        }
    }
}
