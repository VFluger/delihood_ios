//
//  ContentView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.07.2025.
//

import SwiftUI

struct MainScreenView: View {
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        VStack {
            switch authStore.appState {
            case .loading:
                ProgressView()
                    .scaleEffect(2)
                
            case .emailNotVerified:
                EmailVerificationView()
                
            case .loggedIn:
                HomeView()
                
            case .loggedOut:
                LoggedOutWelcomeView()
                
            case .validatingMail:
                ProgressView()
                    .scaleEffect(2)
                Text("Validating mail...")
            case .resetingPassword:
                ResettingPasswordView()
            case .noConnection:
                NoConnectionView(retryFnc: authStore.syncUpdateState)
            }
        }
    }
}



#Preview {
    MainScreenView()
}
