//
//  EmailAndPhoneView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

enum EmailAndPhoneFocusField {
    case email
    case phone
}

struct EmailAndPhoneView: View {
    
    @ObservedObject var vm: RegisterViewModel
    
    @State var isEmailValid = true
    @State var isPhoneValid = true
    
    @FocusState var focusState: EmailAndPhoneFocusField?
    
    var body: some View {
        
        Spacer()
        Text("Where can we reach you?")
            .font(.title2)
            .bold()
        Spacer()
            .frame(height: 35)
        
        EmailView(text: $vm.email,
                  isEmailValid: isEmailValid)
            .focused($focusState, equals: .email)
            .onSubmit {
                if isEmailValid {
                    focusState = .phone
                }
            }
            .onChange(of: vm.email) { oldValue, newValue in
                withAnimation (.easeOut) {
                    isEmailValid = Validator.validateEmail(newValue)
                }
            }
        
        FieldWarningView(isFieldValid: isEmailValid,
                         warningText: WarningMessages.emailWarningText)
        
        TextField("Phone Number", text: $vm.phoneNum)
            .brandStyle(isFieldValid: isPhoneValid)
            .autocorrectionDisabled()
            .keyboardType(.phonePad)
            .textInputAutocapitalization(.none)
            .focused($focusState, equals: .phone)
            .onSubmit {
                if isPhoneValid {
                    withAnimation(.easeOut) {
                        vm.currentStep += 1
                    }
                }
            }
            .onChange(of: vm.phoneNum) { oldValue, newValue in
                withAnimation(.easeOut) {
                    isPhoneValid = Validator.validatePhone(newValue)
                }
            }
        FieldWarningView(isFieldValid: isPhoneValid,
                         warningText: WarningMessages.phoneWarningText)
        Spacer()
        
    }
}

#Preview {
    EmailAndPhoneView(vm: RegisterViewModel())
}
