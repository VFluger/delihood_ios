//
//  FoodListView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import SwiftUI
import RemoteImage

struct FoodListView: View {
    let food: Food
    
    var body: some View {
            HStack {
                CustomRemoteImage(UrlString: food.imageUrl, placeholderView: {
                    Image("food-placeholder")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.primary)
                        .frame(width: 50)
                })
                .frame(width: 100, height: 100)
                .background(.popup)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.horizontal, 10)
                VStack(alignment: .leading) {
                    Text(food.name)
                        .fontWeight(.bold)
                        .padding(.top, 5)
                    
                    Text(food.description)
                        .frame(width: 120, height: 35, alignment: .leading)
                        .font(.footnote)
                        .lineLimit(2)
                        
                    //Converting to CategoryContext
                    if let categoryEnum = CategoryContext(rawValue: food.category) {
                        HStack {
                            Image(categoryEnum.iconName)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.primary)
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text(categoryEnum.name)
                        }
                    }
                    Spacer()
                }
                .frame(height: 80)
                Spacer()
                VStack {
                    Text("\(food.price) Kč")
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .padding()
            }
            .padding(.vertical, 2)
        }
}

#Preview {
    FoodListView(food: Food(id: 1, name: "Pizza", description: "Pizza na pile asdf asdf asdf afd asdf", category: "italien", price: 100, imageUrl: "https://www.abeautifulplate.com/wp-content/uploadasdfs/2015/08/the-best-homemade-margherita-pizza-1-4.jpg"))
}

