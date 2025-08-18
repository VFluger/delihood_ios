//
//  OrderFinishView().swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import SwiftUI

struct OrderFinishView: View {
    @AppStorage("order") var orderData: Data?
    
    @State private var order: Order?
    var body: some View {
        VStack {
            if let order = order {
                ForEach(order.items) {orderItem in
                    Text("\(orderItem.foodId)")
                    Text(orderItem.name)
                    Text("\(orderItem.quantity)")
                    Text("\(orderItem.price * orderItem.quantity)")
                }
            }
            
            Button("Reset order data") {
                orderData = Data()
            }
        }.onAppear {
            if let orderData = orderData {
                order = try? JSONDecoder().decode(Order.self, from: orderData)
            }
        }
        
    }
}

#Preview {
    OrderFinishView()
}
