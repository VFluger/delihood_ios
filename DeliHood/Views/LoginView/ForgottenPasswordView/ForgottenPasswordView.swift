//
//  ForgottenPasswordView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 12.08.2025.
//

import SwiftUI

struct ForgottenPasswordView: View {
    @Binding var isPresented: Bool
    
    @StateObject var vm = ForgottenPasswordViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isPresented = false
                }label: {
                    Image(systemName: "xmark")
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color(UIColor.label))
                        .padding()
                        .glassEffect(
                            .clear
                                .interactive()
                        )
                }.padding()
            }
            VStack {
                Text("Forgotten Password")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                Text("Enter your email address to \nrestore your password.")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                Spacer()
                TextField("Email Address", text: $vm.email)
                    .brandStyle(isFieldValid: true)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onSubmit {
                        vm.submit()
                    }
                Button {
                    vm.submit()
                }label: {
                    BrandBtn(text: "Submit", width: 325)
                        .padding(.top, 20)
                }
                Spacer()
            }
        }
        .alert(item: $vm.alertItem) {alert in
            Alert(title: Text(alert.title), message: Text(alert.description), dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    ForgottenPasswordView(isPresented: .constant(true))
}
