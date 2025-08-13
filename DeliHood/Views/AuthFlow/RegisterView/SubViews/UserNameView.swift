//
//  UsernameView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

struct UserNameView: View {
    
    @ObservedObject var vm: RegisterViewModel
    
    @State var isUsernameValid = true
    
    var body: some View {
        
        Spacer()
        OAuthView(vm: vm)
        Spacer()
            .frame(height: 30)
        
        Text("How should we call you?")
            .font(.title2)
            .bold()
        
        TextField("Username", text: $vm.username)
            .brandStyle(isFieldValid: isUsernameValid)
            .autocorrectionDisabled()
            .onSubmit {
                //Next step
                if !vm.username.isEmpty {
                    withAnimation(.easeOut) {
                        vm.currentStep += 1
                    }
                }
            }
            //Check if valid
            .onChange(of: vm.username) { oldValue, newValue in
                isUsernameValid = !newValue.isEmpty
            }
        Spacer()
        
    }
}

#Preview {
    UserNameView(vm: RegisterViewModel())
}
