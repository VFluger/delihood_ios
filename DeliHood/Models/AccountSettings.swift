//
//  AccountSettings.swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import SwiftUI


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
