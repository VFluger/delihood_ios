//
//  OrderHistoryDetailView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.08.2025.
//

import SwiftUI

struct OrderHistoryDetailView: View {
    var order: OrderHistory
    
    @State private var orderDetail: OrderHistory?
    @State private var alertItem: AlertItem?
    
    private var cancellable: Bool {
        orderDetail?.status == .pending
    }
    
    var body: some View {
        VStack {
            if let orderDetail {
                Text("Order #\(orderDetail.id)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                HStack {
                    Image(systemName: "clock")
                    Text(orderDetail.created_at.timeAgoOrDate())
                        .bold()
                    Text(orderDetail.created_at, style: .time)
                        .bold()
                }
                .font(.headline)
                .padding()
                
                OrderStatusView(status: order.status)
                    .padding(.bottom)
                
                Text("Items: ")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    // Header row
                    HStack {
                        Text("Img")
                            .fontWeight(.semibold)
                            .frame(width: 65) // same width as your image
                        Spacer()
                        Text("Name")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text("Qty")
                            .fontWeight(.semibold)
                            .frame(width: 30)
                        Spacer()
                        Text("Price")
                            .fontWeight(.semibold)
                            .frame(width: 60)
                    }
                    
                    Divider()
                    
                    // Items
                    ForEach(orderDetail.items ?? [], id: \.food_id) { item in
                        OrderItemHistoryListView(item: item)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding()
                Spacer()
                
                Button {
                    alertItem = AlertContext.getSupport
                }label: {
                    Label("Get support", systemImage: "questionmark.message.fill")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundStyle(Color.label)
                        .frame(maxWidth: .infinity)
                        .glassEffect(.regular.interactive())
                }
                .padding(.bottom, 10)
                if cancellable {
                    Button {
                        Task {
                            do {
                                try await NetworkManager.shared.cancelOrder(id: orderDetail.id)
                            }catch {
                                alertItem = AlertContext.cannotCancel
                            }
                        }
                    }label: {
                        Label("Cancel", systemImage: "xmark.app")
                            .fontWeight(.bold)
                            .padding()
                            .foregroundStyle(Color.label)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!cancellable)
                }
            }
        }
        .task {
            do {
                orderDetail = try await NetworkManager.shared.getOrderDetails(id: order.id).data
                print(order)
            }catch {
                print(error)
            }
        }
        .alert(item: $alertItem) {alert in
            Alert(title: Text(alert.title), message: Text(alert.message))
        }
    }
}

struct OrderItemHistoryListView: View {
    var item: OrderItemHistory
    
    private var total: Int {
        item.price_at_order * item.quantity
    }
    
    var body: some View {
        HStack(spacing: 10) {
            CustomRemoteImage {
                Image("food-placeholder")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(.primary)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .frame(width: 60, height: 60)
            .background(.popup)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            Text(item.name)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5)

            Text("\(item.quantity)x")
                .frame(width: 50, alignment: .trailing)

            Text("\(total) Kč")
                .frame(width: 70, alignment: .trailing)
        }
    }
}
