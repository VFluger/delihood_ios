//
//  GoogleRegisterViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import SwiftUI

@MainActor
final class OAuthRegisterViewModel: ObservableObject {
    @Published var phone = ""
    @Published var isConsent = false
    
    @Published var isPhoneValid: Bool = true
    @Published var isLoading: Bool = false
    
    var canProceed: Bool {
        isPhoneValid && isConsent
    }
    
    func updatePhone(oldValue: String, newValue: String) {
        withAnimation(.easeOut) {
            isPhoneValid = Validator.validatePhone(newValue)
        }
    }
    
    func register (authStore: AuthStore, userData: GoogleRegistrationData) async {
            Task {
                isLoading = true
                do {
                    try await AuthManager.shared.register(email: userData.email, phone: phone, name: userData.username)
                    try await NetworkManager.shared.postGoogleToken(token: userData.token)
                    await authStore.updateState()
                    withAnimation(.easeOut) {
                        isLoading = false
                    }
                }catch {
                    withAnimation(.easeOut) {
                        //CANNOT REGISTER
                        isLoading = false
                    }
                }
            }
    }
}
