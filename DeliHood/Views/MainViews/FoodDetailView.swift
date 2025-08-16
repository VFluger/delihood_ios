//
//  FoodDetailView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 16.08.2025.
//

import SwiftUI

struct FoodDetailView: View {
    var food: Food
    var body: some View {
        ScrollView {
            VStack {
                CustomRemoteImage(UrlString: food.imageUrl) {
                    Image("food-placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                }
                .frame(maxWidth: .infinity, maxHeight: 70)
            }
            // Options
            VStack {
                Text("Options")
            }
        }
        //Stick to the bottom
        VStack {
            Button {
                //TODO: ADD TO ORDER
            }label: {
                BrandBtn(text: "Add to order * \(food.price) Kč", width: 325)
            }
        }
    }
}

#Preview {
    FoodDetailView(food: MockData.sampleCook.foods[0])
}
