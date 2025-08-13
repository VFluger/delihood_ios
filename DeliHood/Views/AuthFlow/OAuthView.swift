//
//  OAuthView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI


struct OAuthView: View {
    var vm: OAuthVMProtocol
    
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
                        .foregroundStyle(Color(UIColor.label))
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
    OAuthView(vm: LoginViewModel())
}
