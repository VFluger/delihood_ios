//
//  HomeView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        Text("username: \(authStore.user?.username ?? "NOTHING")")
        Button("Log out") {
            AuthManager.shared.logout()
            authStore.appState = .loggedOut
            authStore.user = nil
        }
    }
}

#Preview {
    HomeView()
}
