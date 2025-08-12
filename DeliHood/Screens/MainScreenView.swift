//
//  ContentView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.07.2025.
//

import SwiftUI

struct MainScreenView: View {
    @EnvironmentObject var authState: AuthState
    
    var body: some View {
        VStack {
            switch authState.userState {
            case .loading:
                ProgressView()
                    .scaleEffect(2)
                
            case .emailNotVerified:
                EmailVerificationView()
                
            case .loggedIn:
                HomeView()
                
            case .loggedOut:
                LogOutView()
                
            case .validatingMail:
                ProgressView()
                    .scaleEffect(2)
                Text("Validating mail...")
            case .resetingPassword:
                ResettingPasswordView()
            }
        }
    }
}

struct LogOutView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(systemName: "person.crop.circle.fill.badge.plus")
                    .font(.system(size: 150))
                Text("Login or create an account...")
                Spacer()
                GeometryReader { geo in
                    VStack {
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .font(.title2)
                                .foregroundStyle(.black)
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
                                .foregroundStyle(.black)
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

struct HomeView: View {
    @EnvironmentObject var authState: AuthState
    
    var body: some View {
        Text("username: \(authState.user?.username ?? "NOTHING")")
        Button("Log out") {
            AuthManager.shared.logout()
            authState.userState = .loggedOut
            authState.user = nil
        }
    }
}


#Preview {
    MainScreenView()
}
