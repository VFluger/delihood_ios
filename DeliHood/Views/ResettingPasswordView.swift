//
//  ResettingPasswordView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

enum ResetPassFocusedField {
    case password
    case confirmPassword
}

struct ResettingPasswordView: View {
    @EnvironmentObject var authState: AuthState
    
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    @State var isPasswordValid = true
    @State var isConfirmPasswordValid = true
    
    @State var alertItem: AlertItem?
    
    @FocusState var focusedField: ResetPassFocusedField?
    
    var body: some View {
        VStack {
            Text("Set your new password")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            Spacer()
            SecureField("Password", text: $password)
                .brandStyle(isFieldValid: isPasswordValid)
                .focused($focusedField, equals: .password)
                .padding(.bottom, 10)
                .onSubmit {
                    focusedField = .confirmPassword
                }
                .onChange(of: password) {oldValue, newValue in
                    withAnimation(.easeOut) {
                        isPasswordValid = Validator.validatePassword(newValue)
                    }
                }
            if !isPasswordValid {
                HStack {
                    Label("Password is not in valid\n 8 characters \n 1 uppercase letter\n 1 number", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    Spacer()
                }
            }
            SecureField("Confirm Password", text: $confirmPassword)
                .brandStyle(isFieldValid: isConfirmPasswordValid)
                .focused($focusedField, equals: .password)
                .onSubmit {
                    //SEND
                }
                .onChange(of: confirmPassword) {oldValue, newValue in
                    withAnimation(.easeOut) {
                        isConfirmPasswordValid = password == newValue
                    }
                }
            if !isConfirmPasswordValid {
                HStack {
                    Label("The confirm has to match the password", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    Spacer()
                }
            }
            Spacer()
                .frame(height: 20)
            Button {
                Task {
                    do {
                        try await NetworkManager.shared.postNewPassword(password: password, token: authState.resetPasswordToken ?? "")
                        alertItem = AlertContext.resetPassSuccess
                        AuthManager.shared.logout()
                        authState.userState = .loggedOut
                    }catch {
                        print(error)
                        alertItem = AlertContext.resetPassFail
                    }
                }
            }label: {
                BrandBtn(text: "Reset Password",
                         disabled: !isPasswordValid && isConfirmPasswordValid,
                         width: 325)
            }
            .padding()
            .disabled(!isPasswordValid && isConfirmPasswordValid)
            Spacer()
        }
        .alert(item: $alertItem) {alert in
            Alert(title: Text(alert.title), message: Text(alert.description), dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    ResettingPasswordView()
}
