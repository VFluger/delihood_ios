//
//  OrderView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.08.2025.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var orderStore: OrderStore
    
    @StateObject var vm = OrderViewModel()
    
    var body: some View {
        VStack {
            Text(String(describing: orderStore.currentOrder?.status))
        }
    }
}

#Preview {
    OrderView()
}
