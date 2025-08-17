//
//  HelpView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack {
            List {
                Section("Email Adress") {
                    VStack(spacing: 15) {
                        Text("Contact us on our email address")
                        // Example email adress, not actually working
                        Link(destination: URL(string: "mailto:support@delihood.com")!) {
                            Label("support@delihood.com", systemImage: "envelope.stack")
                        }
                    }
                    .padding(10)
                }
                Section("Phone") {
                    VStack(spacing: 15) {
                        Text("Call us on our phone line")
                        // Example email adress, not actually working
                        Link(destination: URL(string: "tel:support@delihood.com")!) {
                            Label("546 888 765", systemImage: "phone")
                        }
                    }
                    .padding(10)
                }
                Section("Disclamer") {
                    Text("Making a chat support or FAQ is beyond the scope of this app")
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                }
            }
            
        }
        .navigationTitle("Get help")
    }
}

#Preview {
    HelpView()
}
