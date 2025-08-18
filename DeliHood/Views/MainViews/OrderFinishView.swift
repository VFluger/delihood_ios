//
//  OrderFinishView().swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import SwiftUI

struct OrderFinishView: View {
    @AppStorage("order") var orderData: Data?
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button("Reset order data") {
            orderData = Data()
        }
    }
}

#Preview {
    OrderFinishView()
}
