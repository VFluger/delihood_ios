//
//  QuantityBtn.swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import SwiftUI

struct QuantityBtn: View {
    @Binding var quantity: Int
    @ObservedObject var vm: FoodDetailViewModel
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    quantity -= 1
                    if quantity <= 1 {
                        quantity = 0
                    }
                    vm.addToOrder(quantity: quantity) {
                        print("No dismiss")
                    }
                }
            }label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.label)
            }
            .padding(.horizontal)
            Spacer()
            Text("\(quantity)")
            Spacer()
            Button {
                quantity += 1
                if quantity >= 5 {
                    quantity = 5
                }
                vm.addToOrder(quantity: quantity) {
                    print("No dismiss")
                }
            }label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.label)
            }
            .padding(.horizontal)
        }
        .frame(width: 200)
        .padding()
        .glassEffect(.regular.interactive())
    }
}

#Preview {
    @Previewable @State var quantity: Int = 1
    QuantityBtn(quantity: $quantity, vm: FoodDetailViewModel(food: MockData.sampleCook.foods[0], cook: MockData.sampleCook))
}
