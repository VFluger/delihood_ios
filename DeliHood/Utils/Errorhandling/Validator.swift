//
//  Validator.swift
//  LoginTestApp
//
//  Created by Vojta Fluger on 11.08.2025.
//
import Foundation

enum Validator {
    static func validateEmail(_ email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    static func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,}$"

        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    static func validatePhone(_ phone: String) -> Bool {
        let phoneRegex = #"^\+?[0-9]{9,15}$"#

        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
}
