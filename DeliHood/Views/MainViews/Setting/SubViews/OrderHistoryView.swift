//
//  OrderHistoryView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI

struct OrderHistoryView: View {
    @State private var orders: [OrderHistory] = []
    @State private var isLoading = false
    
    private var tippedDrivers: Int {
        orders.reduce(0) { $0 + $1.tip }
    }
    
    var body: some View {
        VStack {
            if orders.isEmpty {
                ContentUnavailableView(
                    "No orders",
                    systemImage: "receipt",
                    description: Text("You have no orders on your account.\nOrder something!"))
            } else if isLoading {
                LoadingOverlayView()
            } else {
                List {
                    // Stats Section
                    Section(header: Text("Stats:")
                        .font(.title.bold())
                        .padding(.vertical, 2)
                    ) {
                        OrderStats(numOfOrders: orders.count, tips: tippedDrivers)
                    }
                    // Orders Section
                    Section(
                        header:
                            VStack {
                                Text("All orders: ")
                                    .font(.title.bold())
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)    
                                HStack {
                                    Text("Total Price")
                                        .font(.headline)
                                        .frame(width: 100, alignment: .leading)
                                    Text("Status")
                                        .font(.headline)
                                        .frame(width: 100, alignment: .center)
                                    Text("Date")
                                        .font(.headline)
                                        .frame(width: 100, alignment: .trailing)
                                        .offset(x: -50)
                                }
                                .padding(.horizontal, 30)
                            }
                    ) {
                        ForEach(orders.reversed()) { order in
                            NavigationLink(destination: OrderHistoryDetailView(order: order)) {
                                OrderListView(order: order)
                            }
                        }
                    }
                }
            }
        }
        .task {
            isLoading = true
            await loadOrders()
            isLoading = false
        }
        .refreshable {
            await loadOrders()
        }
        .navigationTitle("Orders history")
    }
    
    private func loadOrders() async {
        do {
            orders = try await NetworkManager.shared.getOrders().data
        } catch {
            print(" Failed to load orders:", error)
        }
    }
}

struct OrderStats: View {
    let numOfOrders: Int
    let tips: Int
    
    var body: some View {
        HStack(spacing: 15) {
            Spacer()
            VStack {
                Text(numOfOrders,
                     format: .number.notation(.compactName).precision(.fractionLength(0...1)))
                    .font(.title.bold())
                HStack(spacing: 2) {
                    Image(systemName: "cart")
                    Text("# Orders")
                }
                .foregroundStyle(Color.label.opacity(0.7))
                .font(.footnote)
                .lineLimit(1)
            }
            Spacer()
            VStack {
                HStack(alignment: .bottom, spacing: 5) {
                    Text(tips, format: .number.notation(.compactName).precision(.fractionLength(0...1)))
                        .font(.title.bold())
                    Text("Kč")
                        .font(.caption.bold())
                        .padding(.bottom, 5)
                    
                }
                HStack(spacing: 2) {
                    Image(systemName: "dollarsign.circle")
                    Text("Tips")
                }
                .foregroundStyle(Color.label.opacity(0.7))
                .lineLimit(1)
                .font(.footnote)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    OrderStats(numOfOrders: 1000234, tips: 10510)
}
