//
//  MockData.swift
//  DeliHood
//
//  Created by Vojta Fluger on 16.08.2025.
//

import Foundation

struct MockData {
    static let sampleCook = Cook(id: 1, name: "Testing Cook", description: "A great testing cook with the best food. This has to be reaaalllyyy long to test every edge case because we dont want a broken app.", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTm22VjO_TCWRKrcNuDNMsZ_-ImiEbzGICJVg&s", location_lat: 12.1, location_lng: 12.1, foods: [Food(id: 2, name: "Testing Food", description: "testing description reaealllyy long we have to test every edge case u know its important", category: "asian", price: 100, imageUrl: "https://www.example.com/image.jpg"), Food(id: 3, name: "Testing Food", description: "testing description of the food", category: "italien", price: 100, imageUrl: "https://www.example.com/image.jpg")])
    static let order = Order(id: UUID(), items: [OrderItem(id: UUID(), food: MockData.sampleCook.foods.first!, quantity: 2, note: "Testing")], cook: MockData.sampleCook, status: .delivered , tip: 10)
}
