//
//  OrderManager.swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import SwiftUI

final class OrderManager {
    @AppStorage("order") private var storageOrder: Data = Data()

    static let shared = OrderManager()

    var order: Order? {
        get {
            try? JSONDecoder().decode(Order.self, from: storageOrder)
        }
        set {
            if let newValue = newValue,
               let encoded = try? JSONEncoder().encode(newValue) {
                storageOrder = encoded
            } else {
                storageOrder = Data()
            }
        }
    }

    func save(_ order: Order) {
        self.order = order
    }
}
