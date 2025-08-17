//
//  PrivacyView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        VStack {
            List {
                Section {
                    Link(destination: URL(string: "https://example.com/privacy")!) {
                        Label("Privacy policy", systemImage: "c.circle")
                            .foregroundStyle(Color.label)
                    }
                    Link(destination: URL(string: "https://github.com/VFluger")!) {
                        HStack {
                            Image("github-icon")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundStyle(Color.label)
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text("App made by Vojta Fluger")
                                .foregroundStyle(Color.label)
                        }
                        .padding(5)
                    }
                }
                
                Section {
                    Text("More options and info is beyound the scope of this app")
                        .fontWeight(.semibold)
                        .padding()
                }
            }
            .listStyle(.insetGrouped)
            Spacer()
        }
        .navigationTitle("Privacy")
        .padding()
    }
}

#Preview {
    PrivacyView()
}
