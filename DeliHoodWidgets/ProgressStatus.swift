//
//  ProgressStatus.swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.09.2025.
//

enum ProgressStatus: Double {
    case pending = 0.1
    case paid = 0.25
    case accepted = 0.5
    case waiting_for_pickup = 0.6
    case delivering = 0.8
    case delivered = 1
}

enum EtaStatus: Int {
    case pending = 30
    case paid = 29
    case accepted = 25
    case waiting_for_pickup = 10
    case delivering = 8
    case delivered = 0
}

enum HeadingStatus: String {
    case pending = "Please pay"
    case paid = "Waiting.."
    case accepted = "Cooking food!"
    case waiting_for_pickup = "Waiting..."
    case delivering = "On the way!"
    case delivered = "Bon appetit!"
}

enum DescStatus: String {
    case pending = "Please go back to the app..."
    case paid = "Waiting for the cook to accept your order."
    case accepted = "The cook is already cooking it."
    case waiting_for_pickup = "Food is ready! Waiting for the delivery driver."
    case delivering = "The driver is on the way to you."
    case delivered = "Enjoy your food and come back again!"
}

extension ProgressStatus {
    init?(from status: String) {
        switch status {
        case "pending": self = .pending
        case "paid": self = .paid
        case "accepted": self = .accepted
        case "waiting_for_pickup": self = .waiting_for_pickup
        case "delivering": self = .delivering
        case "delivered": self = .delivered
        default: return nil
        }
    }
}

extension EtaStatus {
    init?(from status: String) {
        switch status {
        case "pending": self = .pending
        case "paid": self = .paid
        case "accepted": self = .accepted
        case "waiting_for_pickup": self = .waiting_for_pickup
        case "delivering": self = .delivering
        case "delivered": self = .delivered
        default: return nil
        }
    }
}
extension HeadingStatus {
    init?(from status: String) {
        switch status {
        case "pending": self = .pending
        case "paid": self = .paid
        case "accepted": self = .accepted
        case "waiting_for_pickup": self = .waiting_for_pickup
        case "delivering": self = .delivering
        case "delivered": self = .delivered
        default: return nil
        }
    }
}
extension DescStatus {
    init?(from status: String) {
        switch status {
        case "pending": self = .pending
        case "paid": self = .paid
        case "accepted": self = .accepted
        case "waiting_for_pickup": self = .waiting_for_pickup
        case "delivering": self = .delivering
        case "delivered": self = .delivered
        default: return nil
        }
    }
}
