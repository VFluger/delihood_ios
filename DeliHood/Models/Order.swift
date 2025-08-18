//
//  Order.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI

enum OrderStatus: String, Codable {
    case notOrdered
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
    
    var cookId: Int?
    
    var deliveryLocationLat: Double?
    var deliveryLocationLng: Double?
    
    var status: OrderStatus
    
    var totalPrice: Int {
        items.reduce(0) { $0 + $1.price }
    }
    var tip: Int
}
