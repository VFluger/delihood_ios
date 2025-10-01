//
//  OrderItem.swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import Foundation


struct OrderItem: Codable, Identifiable {
    var id = UUID()
    
    var food: Food
    var quantity: Int
    
    var note: String?
}

struct OrderItemHistory: Codable {
    let food_id: Int
    let name: String
    let description: String
    let image_url: String
    let quantity: Int
    let price_at_order: Int
}

//Check by UUID
extension OrderItem: Equatable {
    static func == (lhs: OrderItem, rhs: OrderItem) -> Bool {
        return lhs.id == rhs.id
    }
}
