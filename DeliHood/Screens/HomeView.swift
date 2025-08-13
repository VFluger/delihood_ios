//
//  HomeView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

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
    HomeView()
}
