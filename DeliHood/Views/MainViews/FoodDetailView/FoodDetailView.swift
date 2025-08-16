//
//  FoodDetailView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 16.08.2025.
//

import SwiftUI

struct FoodDetailView: View {
    var food: Food
    var cook: Cook
    
    @StateObject var vm = FoodDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                    CustomRemoteImage(UrlString: food.imageUrl) {
                        Image("food-placeholder")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.primary)
                            .scaledToFit()
                            .frame(width: 70, height: 200)
                            .offset(y: 10)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(.popup)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .padding(.horizontal, 5)
                Text(food.name)
                    .font(.title)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                
                CategoryView(string: food.category)
                    .scaleEffect(1.2)
                    .foregroundStyle(.brand)
                
                HStack {
                    CustomRemoteImage(UrlString: cook.imageUrl) {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    
                    NavigationLink(destination: {
                        CookDetailView(cook: cook)
                    }, label: {
                        Text(cook.name)
                            .minimumScaleFactor(0.5)
                            .padding(.horizontal, 5)
                            .foregroundStyle(Color(UIColor.label))
                    })
                    
                }
                .padding(5)
                .background(.popup)
                .clipShape(Capsule())
                .padding(.top, 10)
                .padding(.bottom, 20)
            }
            // Options
            VStack(alignment: .leading) {
                Text("Description:")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                
                Text(food.description)
                    .padding(10)
                    .padding(.horizontal, 15)
                
                Text("Options:")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                VStack(alignment: .leading, spacing: 10) {
                    CheckboxView(isChecked: $vm.isExtraNapkins, text: "Extra napkins")
                    CheckboxView(isChecked: $vm.isExtraSalt, text: "Extra salty")
                    CheckboxView(isChecked: $vm.isGlutenFree, text: "Gluten-free")
                }
                .font(.headline)
                .fontWeight(.medium)
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("Notes: ")
                        .font(.title2)
                        .fontWeight(.semibold)
                    ZStack(alignment: .topLeading) {
                        if vm.notes.isEmpty {
                            Text("eg. no olives, vegan or extra spicy")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 15)
                                .zIndex(1)
                        }
                        
                        TextEditor(text: $vm.notes)
                            .frame(height: 120)
                            .padding(8)
                            .background(.popup)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                }.padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    vm.addToOrder()
                }label: {
                    BrandBtn(text: "Order • \(food.price) Kč", width: 200)
                }
            }
            .sharedBackgroundVisibility(.hidden)
            ToolbarSpacer(.flexible, placement: .bottomBar)
            ToolbarItem(placement: .bottomBar) {
                Button {
                    // Add to favorites
                }label: {
                    Image(systemName: "star")
                }
                .padding(5)
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    
                }label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .padding(5)
            }
        }
    }
}

#Preview {
    FoodDetailView(food: MockData.sampleCook.foods[0], cook: MockData.sampleCook)
}
