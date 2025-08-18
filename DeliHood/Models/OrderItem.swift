//
//  OrderItem.swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import Foundation


struct OrderItem: Codable, Identifiable {
    var id = UUID()
    
    var foodId: Int // Id from db
    var quantity: Int
    var name: String
    var price: Double
    
    var note: String?
}
