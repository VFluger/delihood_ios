//
//  GoogleRegisterView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import SwiftUI

struct OAuthRegisterView: View {
    @EnvironmentObject var authState: AuthStore
    
    var userData: GoogleRegistrationData
    
    @StateObject var vm = OAuthRegisterViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Additional Informations")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            VStack {
                Text("We just need a bit more informations\n from you to get you started")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
                .frame(height: 30)
            
            Text("Your Informations: ")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 10) {
                Label(userData.username, systemImage: "person")
                    .foregroundStyle(.brand)
                Label(userData.email, systemImage: "envelope")
                    .foregroundStyle(.brand)
            }
            .font(.headline)
            .fontWeight(.regular)
            .padding()
            .background(Color.darkgray.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
            .padding(.bottom, 20)
            VStack {
                Text("Where can we reach you?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                TextField("Phone number", text: $vm.phone)
                    .brandStyle(isFieldValid: vm.isPhoneValid)
                    .keyboardType(.phonePad)
                    .onChange(of: vm.phone, vm.updatePhone)
                
                
                FieldWarningView(isFieldValid: vm.isPhoneValid, warningText: WarningMessages.phoneWarningText)
                
                Toggle("Agree to Terms and Conditions", isOn: $vm.isConsent)
                    .toggleStyle(iOSCheckboxToggleStyle())
                    .padding(.bottom, 20)
                
                Button {
                    Task {
                        await vm.register(authState: authState, userData: userData)
                    }
                }label: {
                    BrandBtn(text: "Finish registration", disabled: !vm.canProceed, width: 325)
                }.disabled(!vm.canProceed)
                Spacer()
            }.frame(maxWidth: .infinity)
        }
        .loadingOverlay(vm.isLoading)
        
    }
}

#Preview {
    OAuthRegisterView(userData: GoogleRegistrationData(username: "Vojtech Fluger", email: "testing@example.com", token: "123asdf"))
        .environmentObject(AuthStore())
}
