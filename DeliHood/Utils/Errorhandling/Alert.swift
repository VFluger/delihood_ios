//
//  Alert.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

enum AlertContext {
    static let failRegister = AlertItem(title: "Cannot register",
                                        description: "Sorry, we cannot register you at the moment")
    
    static let failLogin = AlertItem(title: "Cannot login",
                                     description: "Sorry, we cannot log you in at the moment")
    
    static let wrongPassOrMail = AlertItem(title: "Wrong password or email",
                                           description: "Check that your email and password are correct.\n\n If you forgot your password, you can reset it.")
    
    static let networkFail = AlertItem(title: "No Network",
                                       description: "Check your internet connection and try again.\n If the problem persists, please contact support.")
   
    static let userAlreadyInDb = AlertItem(title: "User already registered",
                                           description: "A user with this email, phone or username already exists, please choose a different one.")
    
    //MARK: Reset password
    static let forgottenPasswordSend = AlertItem(title: "Check your email", description: "If this email was registered, you should receive an email with a reset link.")
    static let resetPassSuccess = AlertItem(title: "Password reset successful", description: "Password was reset successfully. You can now log in with your new password.")
    static let resetPassFail = AlertItem(title: "Password reset failed", description: "Cannot reset password at the moment, please try again.")
    
    //MARK: - Generic
    static let cannotGetData = AlertItem(title: "Cannot get data", description: "Cannot get data from the server, please try again later.")
    //MARK: - Invalid and duplicate values
    static let invalidValue = AlertItem(title: "Invalid value", description: "This value is not valid. Check if it contains only allowed symbols.")
    static let duplicateValue = AlertItem(title: "Value not available", description: "User with this value already exists. Please try another one")
}
