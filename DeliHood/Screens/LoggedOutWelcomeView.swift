//
//  LoggedOutWelcomeView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

//Log in or register view
struct LoggedOutWelcomeView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image("delihood-logo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .foregroundStyle(.brand)
                    .padding(.bottom, -50)
                HStack(spacing: 0) {
                    Text("Order food from")
                    Text(" real ")
                        .bold()
                    Text("people!")
                }
                .font(.title)
                Text("Start ordering today.")
                    .font(.title3)
                    .padding(10)
                Spacer()
                GeometryReader { geo in
                    VStack {
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .font(.title2)
                                .foregroundStyle(Color.label)
                                .fontWeight(.semibold)
                                .frame(width: geo.size.width * 0.8)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .glassEffect(
                                    .regular
                                        .tint(Color(.blue).opacity(0.4))
                                        .interactive()
                                )
                        }
                        NavigationLink(destination: RegisterView()) {
                            Text("Register")
                                .font(.title2)
                                .foregroundStyle(Color.label)
                                .fontWeight(.semibold)
                                .frame(width: geo.size.width * 0.8)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .glassEffect(
                                    .regular
                                        .interactive()
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 150) // limit height for GeometryReader so it doesn't expand full screen
            }
            .padding()
        }
    }
}

#Preview {
    LoggedOutWelcomeView()
}
