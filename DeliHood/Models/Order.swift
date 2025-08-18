//
//  Order.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI

enum OrderStatus: String, Codable {
//    'pending', 'paid', 'accepted', 'waiting for pickup', 'delivering', 'delivered'
    case pending
    case paid
    case accepted
    case waitingForPickup = "waiting for pickup"
    case delivering
    case delivered
}

struct Order: Codable, Identifiable {
    var id: UUID
    var items: [OrderItem]
    
    var deliveryLocationLat: Double
    var deliveryLocationLng: Double
    
    var status: OrderStatus
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }
    var tip: Int
}
