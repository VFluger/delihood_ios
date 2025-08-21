//
//  OrderStore.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.08.2025.
//

import SwiftUI


enum PaymentStatus {
    case notStarted
    case pending
    case succeeded
    case failed(error: Error)
    case canceled
}

@MainActor
class OrderStore: ObservableObject {
    @Published var currentOrder: Order? = nil
    @Published var paymentStatus: PaymentStatus = .notStarted
    
    init() {
        Task {
            do {
                try await self.updateStatus()
            } catch {
                print("updateStatus failed:", error)
            }
        }
    }
    
    func updateStatus() async throws {
            let orders = try await NetworkManager.shared.getOrders()
            let lastOrder = orders.data.last
        if lastOrder?.status == .delivered || lastOrder == nil {
            print("No order")
            currentOrder = nil
            paymentStatus = .notStarted
        }
            currentOrder = lastOrder
    }
    
    func cancelCurrentOrder() async throws {
        
    }
}
