//
//  FoodDetailViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 16.08.2025.
//

import SwiftUI

final class FoodDetailViewModel: ObservableObject {
    @Published var isExtraNapkins = false
    @Published var isExtraSalt = false
    @Published var isGlutenFree = false
    @Published var notes = ""
    
    @Published var alertItem: AlertItem? = nil
    
    func addToOrder() {
        print("adding to order in SwiftData")
    }
}
