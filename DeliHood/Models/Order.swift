//
//  Order.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI

// same enum as in db, notOrdered added
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
    
    var cookId: Int? // To display only foods from the same cook
    
    var deliveryLocationLat: Double?
    var deliveryLocationLng: Double?
    
    var status: OrderStatus
    
    var totalPrice: Int {
        items.reduce(0) { $0 + $1.price * $1.quantity }
    }
    var tip: Int
}
