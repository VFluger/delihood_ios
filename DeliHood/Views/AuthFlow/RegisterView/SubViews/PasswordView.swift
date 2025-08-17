//
//  PasswordView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI


enum PasswordFocusedField {
    case password
    case confirmPassword
}

struct PasswordView: View {
    @ObservedObject var vm: RegisterViewModel
    @ObservedObject var authStore: AuthStore
    
    @State var isPasswordValid: Bool = true
    @State var isConfirmValid: Bool = true
    
    @FocusState var focusedField: PasswordFocusedField?
    
    var body: some View {
        Spacer()
        
        SecureField("Password", text: $vm.password)
            .brandStyle(isFieldValid: isPasswordValid)
            .focused($focusedField, equals: .password)
            .onChange(of: vm.password) { oldValue, newValue in
                isPasswordValid = Validator.validatePassword(newValue)
            }
            .onSubmit {
                if isPasswordValid {
                    focusedField = .confirmPassword
                }
            }
        
        FieldWarningView(isFieldValid: isPasswordValid,
                         warningText: WarningMessages.passwordWarningText)
        
        SecureField("Confirm Password", text: $vm.confirmPassword)
            .brandStyle(isFieldValid: isConfirmValid)
            .focused($focusedField, equals: .confirmPassword)
            .onChange(of: vm.confirmPassword) { oldValue, newValue in
                isConfirmValid = vm.password == newValue
            }
            .onSubmit {
                if isConfirmValid && isPasswordValid {
                    //SUBMIT
                    Task {
                        await vm.registerUser()
                        await authStore.updateState()
                    }
                }
            }
        FieldWarningView(isFieldValid: isConfirmValid,
                         warningText: WarningMessages.confirmPassWarningText)
        
        CheckboxView(isChecked: $vm.isConsent, text: "Accept Terms of Service")
            .padding()
            .foregroundStyle(Color.label)
        Spacer()
            .frame(height: 40)
        
        Button {
            Task {
                await vm.registerUser()
                await authStore.updateState()
            }
        } label: {
            if vm.isLoading {
                BrandIconBtn(imageName: "hourglass")
                    .symbolEffect(.rotate.byLayer, options: .repeat(.continuous))
            }else {
                BrandBtn(text: "Register",
                         disabled: !vm.canProceed,
                         width: 325)
                .font(.title2)
                .bold()
            }
        }
        .disabled(!vm.canProceed)
    }
}

#Preview {
    PasswordView(vm: RegisterViewModel(), authStore: AuthStore())
}
