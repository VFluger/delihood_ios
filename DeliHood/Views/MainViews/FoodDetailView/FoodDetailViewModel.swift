//
//  FoodDetailViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 16.08.2025.
//

import SwiftUI

final class FoodDetailViewModel: ObservableObject {
    @Published var food: Food
    @Published var cook: Cook
    
    @AppStorage("order") var order: Data?
    
    @Published var isExtraNapkins = false
    @Published var isExtraSalt = false
    @Published var isGlutenFree = false
    @Published var notes = ""
    
    @Published var alertItem: AlertItem? = nil
    
    init(food: Food, cook: Cook, isExtraNapkins: Bool = false, isExtraSalt: Bool = false, isGlutenFree: Bool = false, notes: String = "", alertItem: AlertItem? = nil) {
        self.food = food
        self.cook = cook
        self.isExtraNapkins = isExtraNapkins
        self.isExtraSalt = isExtraSalt
        self.isGlutenFree = isGlutenFree
        self.notes = notes
        self.alertItem = alertItem
    }
    
    @MainActor func addToOrder(dismiss: @escaping () -> Void) {
        let orderItem = OrderItem(foodId: food.id, quantity: 1, name: food.name, price: food.price, note: notes)
        do {
            //Try to append to existing order
            var decodedOrder = try JSONDecoder().decode(Order.self, from: order ?? Data())
            //Order exists
            guard cook.id == decodedOrder.cookId else {
                //Ordering a food thats not from the same cook
                alertItem = AlertContext.cannotAddToOrder
                return
            }
            
            decodedOrder.items.append(orderItem)
            decodedOrder.cookId = cook.id
            let encodedOrder = try JSONEncoder().encode(decodedOrder)
            order = encodedOrder
            dismiss()
            
        }catch {
            print(error)
            // Create a new order
            let newOrder = Order(id: UUID(), items: [orderItem], cookId: cook.id, status: .notOrdered, tip: 0)
            let encodedOrder = try? JSONEncoder().encode(newOrder)
            order = encodedOrder
            dismiss()
        }
    }
}
