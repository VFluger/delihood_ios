//
//  RegisterView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 12.08.2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authState: AuthState
    @StateObject var vm = RegisterViewModel()

    
    var body: some View {
        VStack {
            Text("Registration")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Text("Create a new account\n and start ordering right now")
                .multilineTextAlignment(.center)
            
            if vm.currentStep == 0 {
                UserNameView(vm: vm)
            } else if vm.currentStep == 1 {
                EmailAndPhoneView(vm: vm)
            } else if vm.currentStep == 2 {
                PasswordView(vm: vm, authState: authState)
            }
            Spacer()
            HStack {
                if vm.currentStep > 0 {
                    Button {
                        withAnimation(.easeOut) {
                            vm.currentStep -= 1
                        }
                    }label: {
                        BrandIconBtn(imageName: "chevron.left")
                    }
                }
                
                Spacer()
                
                if vm.currentStep < 2 {
                    Button {
                        withAnimation(.easeOut) {
                            vm.currentStep += 1
                        }
                    }label: {
                        BrandIconBtn(imageName: "chevron.right",
                                     disabled: !vm.isCurrentStepValid)
                    }
                    .disabled(!vm.isCurrentStepValid)
                }
            }
            .padding()
        }
        .padding()
        .alert(item: $vm.alertItem) {alert in
            Alert(title: Text(alert.title), message: Text(alert.description))
        }
    }
}

struct UserNameView: View {
    
    @ObservedObject var vm: RegisterViewModel
    
    @State var isUsernameValid = true
    
    var body: some View {
        Spacer()
        Text("How should we call you?")
            .font(.title2)
            .bold()
        TextField("Username", text: $vm.username)
            .brandStyle(isFieldValid: isUsernameValid)
            .autocorrectionDisabled()
            .onSubmit {
                if !vm.username.isEmpty {
                    withAnimation(.easeOut) {
                        vm.currentStep += 1
                    }
                }
            }
            .onChange(of: vm.username) { oldValue, newValue in
                isUsernameValid = !newValue.isEmpty
            }
        Spacer()
        
    }
}

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
        TextField("Email Address", text: $vm.email)
            .brandStyle(isFieldValid: isEmailValid)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
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
        if !isEmailValid {
            HStack {
                Label("Email is not in valid format", systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.red)
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                Spacer()
            }
        }else {
            Spacer()
                .frame(height: 20)
        }
        
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
        if !isPhoneValid {
            HStack {
                Label("Phone is not in valid format", systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.red)
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                Spacer()
            }
        }else {
            Spacer()
                .frame(height: 20)
        }
        Spacer()
        
    }
}

enum PasswordFocusedField {
    case password
    case confirmPassword
}

struct PasswordView: View {
    @ObservedObject var vm: RegisterViewModel
    @ObservedObject var authState: AuthState
    
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
        SecureField("Confirm Password", text: $vm.confirmPassword)
            .brandStyle(isFieldValid: isConfirmValid)
            .focused($focusedField, equals: .confirmPassword)
            .onChange(of: vm.confirmPassword) { oldValue, newValue in
                isConfirmValid = vm.password == newValue
            }
            .onSubmit {
                if isConfirmValid && isPasswordValid {
                    //SUBMIT
                    vm.registerUser()
                    authState.userState = .emailNotVerified
                }
            }
            if !isConfirmValid {
                HStack {
                    Label("Confirm has to match the password", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    Spacer()
                }
            }
        Toggle("Accept Terms of Service", isOn: $vm.isConsent)
            .toggleStyle(iOSCheckboxToggleStyle())
            .padding()
            .foregroundStyle(Color(UIColor.label))
        Spacer()
            .frame(height: 40)
        
        Button {
            vm.registerUser()
            authState.userState = .emailNotVerified
        } label: {
            BrandBtn(text: "Register",
                     disabled: !vm.canProceed,
                     width: 325)
                .font(.title2)
                .bold()
        }
        .disabled(!vm.canProceed)
    }
}

#Preview {
    RegisterView()
}
