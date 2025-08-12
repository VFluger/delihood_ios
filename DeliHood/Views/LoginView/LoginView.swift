//
//  LoginView.swift
//  LoginTestApp
//
//  Created by Vojta Fluger on 11.08.2025.
//

import SwiftUI
import GoogleSignIn
import Foundation

enum FocusedField {
    case email
    case password
}

struct LoginView: View {
    @EnvironmentObject var authState: AuthState
    
    @StateObject var vm = LoginViewModel()
    
    private var notificationFeedback = UINotificationFeedbackGenerator()
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationStack {
            Text("Log in")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("Log back into your account,\n and order delicious food.")
                .multilineTextAlignment(.center)
            Spacer()
                .frame(height: 40)
            OAuthView(vm: vm)
            Spacer()
                .frame(height: 40)
            
            EmailTextView(email: $vm.email, isEmailValid: $vm.isEmailValid)
            PasswordTextView(password: $vm.password, isPasswordValid: $vm.isPasswordValid, vm: vm)
            
            Button {
                vm.isForgottenSheetPresented.toggle()
            }label: {
                Text("Forgot your password?")
                    .padding()
                    .foregroundStyle(.primary)
            }
            
            Button {
                Task {
                    vm.loginUser()
                    authState.userState = .loggedIn
                }
            }label: {
                Text("Sign in")
                    .frame(width: 325)
                    .font(.title2)
                    .padding()
                    .foregroundStyle(Color(UIColor.label))
                    .bold()
                    .glassEffect(
                        .regular
                        .tint(.brand.opacity(0.3))
                        .interactive(vm.canProceed)
                    )
                    .opacity(vm.canProceed ? 1 : 0.5)
            }
            .disabled(!vm.canProceed)
            
            Spacer()
        }
        .sheet(isPresented: $vm.isForgottenSheetPresented) {
            ForgottenPasswordView(isPresented: $vm.isForgottenSheetPresented)
        }
        .alert(item: $vm.alertItem) {alert in
            notificationFeedback.notificationOccurred(.warning)
            return Alert(title: Text(alert.title), message: Text(alert.description), dismissButton: .default(Text("Ok")))
            
        }
        
    }
}

struct EmailTextView: View {
    
    @Binding var email: String
    @Binding var isEmailValid: Bool
    
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        TextField("Email", text: $email)
            .brandStyle(isFieldValid: isEmailValid)
            .focused($focusedField, equals: .email)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onChange(of: email) {oldValue, newValue in
                withAnimation(.easeOut(duration: 0.5)) {
                    if newValue.isEmpty {
                        isEmailValid = true
                        return
                    }
                    
                    isEmailValid = Validator.validateEmail(newValue)
                }
            }
            .onSubmit {
                focusedField = .password
            }
            .submitLabel(.next)
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
    }
}

struct PasswordTextView: View {
    @Binding var password: String
    @Binding var isPasswordValid: Bool
    
    var vm: LoginViewModel
    
    @FocusState var focusedField: FocusedField?
    var body: some View {
        SecureField("Password", text: $password)
            .brandStyle(isFieldValid: isPasswordValid)
            .focused($focusedField, equals: .password)
            .onChange(of: password) {oldValue, newValue in
                withAnimation(.easeOut(duration: 0.5)) {
                    if newValue.isEmpty {
                        isPasswordValid = true
                        return
                    }
                    
                    isPasswordValid = Validator.validatePassword(newValue)
                }
            }
            .onSubmit {
                focusedField = nil
                //SUBMIT
                vm.loginUser()
            }
            .submitLabel(.send)
        if !isPasswordValid {
            HStack {
                Label("Password should be \n8 characters\n at least 1 upper case letter\n at least one number.", systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.red)
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                Spacer()
            }
            
        }
    }
}

struct OAuthView: View {
    var vm: LoginViewModel
    var body: some View {
        VStack {
            Text("Continue with: ")
                .padding(.bottom, 10)
                .font(.title3)
            HStack {
                Button {
                    vm.googleSign()
                }label: {
                    Image("google-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(.brand.opacity(0.2))
                        .clipShape(Capsule())
                }
                Button {
                    
                }label: {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.black)
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(.brand.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            
        }
    }
}

#Preview {
    LoginView()
}

