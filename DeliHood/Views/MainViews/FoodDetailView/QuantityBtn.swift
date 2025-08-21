//
//  QuantityBtn.swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import SwiftUI

struct QuantityBtn: View {
    @Binding var quantity: Int
    let callback: (_ quantity: Int) -> Void
    var body: some View {
        HStack {
            Button {
                    if quantity <= 1 {
                        quantity = 0
                        callback(quantity)
                    }else {
                        quantity -= 1
                        callback(quantity)
                    }
            }label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.label)
            }
            .padding(.horizontal, 5)
            Spacer()
            Text("\(quantity)")
                .foregroundStyle(Color.label)
            Spacer()
            Button {
                if quantity >= 5 {
                    quantity = 5
                    callback(quantity)
                }else {
                    quantity += 1
                    callback(quantity)
                }
            }label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.label)
            }
            .padding(.horizontal)
        }
        .frame(width: 200)
        .padding(15)
        .glassEffect(.regular.interactive())
    }
}

#Preview {
    @Previewable @State var quantity: Int = 1
    QuantityBtn(quantity: $quantity) {qnt in
        quantity = qnt
    }
}
