//
//  ContentView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.07.2025.
//

import SwiftUI

struct MainScreenView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Testing")
            }
            .padding()
            .toolbar {
                MainScreenToolbar()
            }
            .navigationTitle("Welcome, Vojtik!")
        }
    }
}

#Preview {
    MainScreenView()
}
