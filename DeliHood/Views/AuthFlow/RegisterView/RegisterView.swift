//
//  RegisterView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 12.08.2025.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @StateObject var vm = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Registration")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Create a new account\n and start ordering right now")
                .multilineTextAlignment(.center)
            
            // Steps showing different views
            switch vm.currentStep {
            case 0:
                UserNameView(vm: vm)
            case 1:
                EmailAndPhoneView(vm: vm)
            case 2:
                PasswordView(vm: vm, authStore: authStore)
            default:
                //Error
                EmptyView()
            }
            
            Spacer()
            HStack {
                //Back btn
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
                
                //Forward btn
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
        .noConnectionOverlay($vm.hasNoConnection, retryFnc: vm.registerUser)
        .alert(item: $vm.alertItem) {alert in
            Alert(title: Text(alert.title), message: Text(alert.message))
        }
    }
}

#Preview {
    RegisterView()
}
