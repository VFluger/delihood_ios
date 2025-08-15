//
//  CookDetailView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 15.08.2025.
//

import SwiftUI

struct CookDetailView: View {
    var cook: Cook
    
    var body: some View {
        Text(cook.name)
    }
}

#Preview {
    CookDetailView(cook: Cook(id: 1, name: "Testing Cook", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTm22VjO_TCWRKrcNuDNMsZ_-ImiEbzGICJVg&s", location_lat: 12.1, location_lng: 12.1, foods: [Food(id: 2, name: "Testing Food", description: "testing description", category: "asian", price: 100, imageUrl: "https://www.example.com/image.jpg")]))

}
