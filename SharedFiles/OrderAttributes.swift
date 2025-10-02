//
//  OrderAttributes.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.09.2025.
//
import Foundation
import ActivityKit


struct OrderAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var status: String
    }
    
    var orderId: Int
}
