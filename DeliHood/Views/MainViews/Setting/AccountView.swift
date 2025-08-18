//
//  AccountView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 16.08.2025.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authStore: AuthStore
    
    @State private var showLogoutAlert = false
    
    var body: some View {
        //Shouldn't really happen but just to be sure
        if authStore.user == nil {
            VStack {
                Text("Cannot show Account View")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Please try again later.")
                    .padding(10)
            }
        }else {
            List {
                Section {
                    AccountInfoView(user: authStore.user!)
                }
                
                Section {
                    NavigationLink(destination: OrderHistoryView()) {
                        Label("Order history", systemImage: "receipt")
                    }
                    
                }
                
                Section {
                    ForEach(AccountSetting.allCases) {setting in
                        NavigationLink(destination: setting.destination) {
                            Label(setting.label, systemImage: setting.icon)
                        }
                    }
                }
                Section {
                    Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
                        .onTapGesture {
                            showLogoutAlert = true
                        }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Account")
            //Close btn
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Log Out"),
                    message: Text("Are you sure you want to log out? You will need to sign in again to use your account."),
                    primaryButton: .destructive(Text("Log out")) {
                        AuthManager.shared.logout()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct AccountInfoView: View {
    let user: User
    
    var body: some View {
        HStack {
            CustomRemoteImage(UrlString: user.imageUrl, placeholderView: {
                Image(systemName: "person")
                    .scaleEffect(1.5)
            })
            .frame(width: 100, height: 100)
            .background(.popup)
            .clipShape(Circle())
            .padding(5)
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                Label(user.phone.formattedPhone(), systemImage: "phone")
                    .padding(.bottom, 5)
                Label(user.email, systemImage: "envelope")
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .minimumScaleFactor(0.5)
            }
            .padding(.vertical)
        }
    }
}

enum AccountSetting: String, CaseIterable, Identifiable {
    case changeAccountSettings
    case privacy
    case notifications
    case help

    var id: String { self.rawValue }

    var label: String {
        switch self {
        case .changeAccountSettings: return "Change Account Settings"
        case .privacy: return "Privacy"
        case .notifications: return "Notifications"
        case .help: return "Help & Support"
        }
    }

    var icon: String {
        switch self {
        case .changeAccountSettings: return "person.2.badge.gearshape"
        case .privacy: return "lock.shield"
        case .notifications: return "bell.badge"
        case .help: return "questionmark.circle"
        }
    }
    var destination: AnyView {
        switch self {
        case .changeAccountSettings: return AnyView(ChangeSettingsView())
        case .privacy: return AnyView(PrivacyView())
        case .notifications: return AnyView(NotificationsView())
        case .help: return AnyView(HelpView())
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(AuthStore())
}
