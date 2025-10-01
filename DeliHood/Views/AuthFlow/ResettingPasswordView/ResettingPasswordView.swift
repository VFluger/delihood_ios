//
//  ResettingPasswordView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

struct ResettingPasswordView: View {
    @EnvironmentObject var authStore: AuthStore
    
    @StateObject var vm = ResettingPasswordViewModel()
    
    
    var body: some View {
        VStack {
            Text("Set your new password")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            Spacer()
            
            ResetPasswordView(vm: vm, authStore: authStore)
            
            ConfirmPasswordView(vm: vm, authStore: authStore)
            
            Button {
                Task {
                    vm.resetPassword(token: authStore.resetPasswordToken ?? "")
                }
            }label: {
                BrandBtn(text: "Reset Password",
                         disabled: vm.isBtnDisabled,
                         width: 325)
            }
            .padding()
            .disabled(vm.isBtnDisabled)
            Spacer()
        }
        .alert(item: $vm.alertItem) {alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .default(Text("Ok")) {
                // Log out user
                withAnimation(.easeOut) {
                    Task {
                        let isLoggedOut = await AuthManager.shared.logout()
                        guard isLoggedOut else {
                            return
                        }
                    }
                        authStore.appState = .loggedOut
                }
            })
        }
    }
}

struct ConfirmPasswordView: View {
    @ObservedObject var vm: ResettingPasswordViewModel
    @ObservedObject var authStore: AuthStore
    
    var body: some View {
        SecureField("Confirm Password", text: $vm.confirmPassword)
            .brandStyle(isFieldValid: vm.isConfirmPasswordValid)
            .onSubmit {
                Task {
                    vm.resetPassword(token: authStore.resetPasswordToken ?? "")
                }
            }
            .onChange(of: vm.confirmPassword) {oldValue, newValue in
                withAnimation(.easeOut) {
                    vm.isConfirmPasswordValid = vm.password == newValue
                }
            }
        
        FieldWarningView(isFieldValid: vm.isConfirmPasswordValid, warningText: WarningMessages.confirmPassWarningText)
        
        Spacer()
            .frame(height: 20)
    }
}

struct ResetPasswordView: View {
    @ObservedObject var vm: ResettingPasswordViewModel
    @ObservedObject var authStore: AuthStore
    
    var body: some View {
        SecureField("Password", text: $vm.password)
            .brandStyle(isFieldValid: vm.isPasswordValid)
            .padding(.bottom, 10)
            .onChange(of: vm.password) {oldValue, newValue in
                withAnimation(.easeOut) {
                    vm.isPasswordValid = Validator.validatePassword(newValue)
                }
            }
        
        FieldWarningView(isFieldValid: vm.isPasswordValid, warningText: WarningMessages.passwordWarningText)
    }
}

#Preview {
    ResettingPasswordView()
        .environmentObject(AuthStore())
}
