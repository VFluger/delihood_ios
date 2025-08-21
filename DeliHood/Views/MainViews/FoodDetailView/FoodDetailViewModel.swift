//
//  FoodDetailViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 16.08.2025.
//

import SwiftUI

@MainActor
final class FoodDetailViewModel: ObservableObject {
    @Published var food: Food
    @Published var cook: Cook
    
    @Published var showSuccess: Bool = false
    
    @Published var itemQuantity: Int? = nil
    
    @AppStorage("order") var order: Data?
    
    @Published var isExtraNapkins = false
    @Published var isExtraSalt = false
    @Published var isGlutenFree = false
    @Published var notes = ""
    
    @Published var alertItem: AlertItem? = nil
    
    init(food: Food, cook: Cook) {
        self.food = food
        self.cook = cook
        self.showSuccess = false
        self.isExtraNapkins = false
        self.isExtraSalt = false
        self.isGlutenFree = false
        self.notes = ""
        self.alertItem = nil
        self.itemQuantity = nil
    }
    
    func checkQuantity() -> Int? {
        do {
            if let order {
                let decodedOrder = try JSONDecoder().decode(Order.self, from: order)
                let indexOfItem = decodedOrder.items.firstIndex(where: { $0.food.id == food.id })
                if let indexOfItem {
                    return decodedOrder.items[indexOfItem].quantity
                }
                return nil
            }
        }catch {
            print(error)
        }
        return nil
    }
    
    func addToOrder(quantity: Int = 1 , dismiss: @escaping () -> Void) {
        let orderItem = OrderItem(food: food, quantity: quantity, note: notes)
        do {
            //Try to append to existing order
            var decodedOrder = try JSONDecoder().decode(Order.self, from: order ?? Data())
            //Order exists
            guard cook.id == decodedOrder.cook?.id else {
                //Ordering a food thats not from the same cook
                alertItem = AlertContext.cannotAddToOrder
                return
            }
            // Check if food already in order
            if let existingIndex = decodedOrder.items.firstIndex(where: { $0.food.id == orderItem.food.id }) {
                // Food already exists in order, increase quantity
                decodedOrder.items[existingIndex].quantity = quantity
                
                // If quantity 0, remove from order
                if decodedOrder.items[existingIndex].quantity <= 0 {
                    decodedOrder.items.remove(at: existingIndex)
                }
            } else {
                // Food not in order, append new item
                decodedOrder.items.append(orderItem)
            }
            decodedOrder.cook = cook
            let encodedOrder = try JSONEncoder().encode(decodedOrder)
            order = encodedOrder
            
            Task {
                withAnimation {
                    showSuccess = true
                }
                try await Task.sleep(nanoseconds: 2_000_000_000)
                dismiss()
            }
            
        }catch {
            print(error)
            // Create a new order
            let newOrder = Order(id: UUID(), items: [orderItem], cook: cook, status: .notOrdered, tip: 0)
            let encodedOrder = try? JSONEncoder().encode(newOrder)
            order = encodedOrder
            
            Task {
                withAnimation {
                    showSuccess = true
                }
                try await Task.sleep(nanoseconds: 2_000_000_000)
                dismiss()
            }
        }
    }
}
