//
//  FoodAddedToOrderView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import SwiftUI

struct FoodAddedToOrderView: View {
    @State private var drawAnimation: Bool = true
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
            VStack {
                Spacer()
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .symbolEffect(.drawOn, isActive: drawAnimation)
                    .scaledToFit()
                    .frame(width: 50)
                    .foregroundStyle(.green)
                Spacer()
                    .frame(height: 30)
                Text("Item added to order!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
        }
        .frame(width: 300, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .onAppear {
            drawAnimation.toggle()
        }
    }
}

#Preview {
    FoodAddedToOrderView()
}
