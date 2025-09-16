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
                try await Task.sleep(nanoseconds: 20_000_000) //Waiting for AuthStore to finish
                try await self.updateStatus()
            } catch {
                print("updateStatus failed:", error)
            }
        }
    }
    
    func updateStatus() async throws {
        // Checks last order exists and isnt delivered
        // If yes then asign to currentOrder
        let orders = try await NetworkManager.shared.getOrders()
        let lastOrder = orders.data.last
        guard let lastOrder = lastOrder else {
            print("No orders")
            currentOrder = nil
            paymentStatus = .notStarted
            return
        }
        if lastOrder.status == .delivered {
            print("No active order")
            currentOrder = nil
            paymentStatus = .notStarted
            return
        }
        currentOrder = Order(serverId: lastOrder.id, items: [], status: lastOrder.status, tip: lastOrder.tip)
    }
    
    func cancelCurrentOrder() async throws {
        try await NetworkManager.shared.cancelOrder(id: currentOrder?.serverId ?? -1)
    }
}
