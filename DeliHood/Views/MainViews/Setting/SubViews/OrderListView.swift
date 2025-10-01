//
//  OrderListView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.08.2025.
//

import SwiftUI

struct OrderListView: View {
    var order: OrderHistory
    
    var body: some View {
        HStack(spacing: 10) {
            Text("\(order.total_price) Kč")
                .frame(maxWidth: .infinity, alignment: .leading)
            OrderStatusView(status: order.status)
                .frame(width: 120, alignment: .center)
            Text(order.created_at.timeAgoOrDate())
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.footnote)
        .padding(.horizontal)
    }
}

struct OrderStatusView: View {
    var status: OrderStatus
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(Color("\(status)"))
                .frame(width: 10, height: 10)
            Text(status.rawValue.capitalized)
                .lineLimit(1)
                .layoutPriority(1)
        }
        .padding(5)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}
