//
//  NotificationsView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI

struct NotificationsView: View {
    //TODO: Add to swiftdata
    @State private var allNotif = true
    @State private var orderStatusNotif = true
    @State private var orderDelayedNotif = true
    @State private var dealsNotify = true
    @State private var sellsNotify = true
    
    var body: some View {
        List {
            Section("Disclaimer") {
                Text("This is just a preview, no backend changes will take place")
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
            }
            Section {
                Toggle("All notifications", isOn: $allNotif)
            }
            if allNotif {
                Section("Order") {
                    Toggle("Order status", isOn: $orderStatusNotif)
                    Toggle("Order delayed", isOn: $orderDelayedNotif)
                }
                Section("Marketing") {
                    Toggle("Exclusive deals", isOn: $dealsNotify)
                    Toggle("New sales and promotions", isOn: $sellsNotify)
                }
                Section("Mandatory") {
                    Toggle("When loged in from new device", isOn: .constant(true))
                        .disabled(true)
                    Toggle("Account action needed ", isOn: .constant(true))
                        .disabled(true)
                }
            }
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Notifications")
    }
}

#Preview {
    NotificationsView()
}
