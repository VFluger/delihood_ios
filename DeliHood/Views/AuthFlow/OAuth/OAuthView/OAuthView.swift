//
//  OAuthView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

struct OAuthView: View {
    @EnvironmentObject var authStore: AuthStore
    var parentVm: OAuthVMProtocol
    
    @StateObject var vm = OAuthViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Continue with: ")
                    .padding(.bottom, 10)
                    .font(.title3)
                HStack {
                    Button {
                        Task {
                            guard let result = await vm.signIn(parentVm.googleSign) else {
                                return
                            }
                            
                            //User logged in
                            if result {
                                await authStore.updateState()
                            }
                        }
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
                            .foregroundStyle(Color.label)
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(.brand.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
            }
            
        }
        .loadingOverlay(vm.isLoading)
        .navigationDestination(item: $vm.needsRegistrationData) {(userData: GoogleRegistrationData) in
            OAuthRegisterView(userData: userData)
        }
    }
}

#Preview {
    OAuthView(parentVm: LoginViewModel())
}
