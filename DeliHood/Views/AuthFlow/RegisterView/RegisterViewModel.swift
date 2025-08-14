//
//  RegisterViewModel.swift
//  LoginTestApp
//
//  Created by Vojta Fluger on 12.08.2025.
//
import SwiftUI


@MainActor
final class RegisterViewModel: ObservableObject, OAuthVMProtocol {
    
    //Form data
    @Published var currentStep = 0
    @Published var username = ""
    @Published var email = ""
    @Published var phoneNum = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isConsent = false
    
    @Published var isLoading = false
    @Published var hasNoConnection = false
    
    @Published var alertItem: AlertItem?
    
    var isCurrentStepValid: Bool {
        switch currentStep {
        case 0:
            return !username.isEmpty
        case 1:
            return Validator.validateEmail(email) && Validator.validatePhone(phoneNum)
        case 2:
            return Validator.validatePassword(password) && password == confirmPassword && isConsent
        default:
            return false
        }
    }
    
    var canProceed: Bool {
        Validator.validateEmail(email) && Validator.validatePassword(password) && password == confirmPassword && Validator.validatePhone(phoneNum) && isConsent
    }
    
    //Register, then log in, if error, show the alertItem
    func registerUser() async {
        isLoading = true
            do {
                try await AuthManager.shared.register(email: email, password: password, phone: phoneNum, name: username)
                try await AuthManager.shared.login(email: email,
                                                   password: password)
                isLoading = false
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                
            }catch {
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    hasNoConnection = true
                } else {
                    switch error {
                    case AuthError.userAlreadyInDb:
                        alertItem = AlertContext.userAlreadyInDb
                    case AuthError.cannotGetToken:
                        alertItem = AlertContext.failRegister
                    default:
                        alertItem = AlertContext.failRegister
                    }
                }
                isLoading = false
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            }
    }
}
