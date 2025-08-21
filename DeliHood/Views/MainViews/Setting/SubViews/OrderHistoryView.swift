//
//  OrderHistoryView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI

struct OrderHistoryView: View {
    @State private var orders: [OrderHistory] = []
    
    private var numOfOrders: Int {
        orders.count
    }
    
    private var tippedDrivers: Int {
        orders.reduce(0) { $0 + $1.tip }
    }

    private var moneySpend: Int {
        orders.reduce(0) { $0 + $1.total_price }
    }
    
    var body: some View {
        NavigationView {
            if orders.isEmpty {
                ContentUnavailableView(
                    "No orders",
                    systemImage: "receipt",
                    description: Text("You have no orders on your account.\nOrder something!")
                )
                .task {
                    await loadOrders()
                }
                .refreshable {
                    await loadOrders()
                }
                .navigationTitle("Orders history")
            } else {
                List {
                    // Stats Section
                    Section(header: Text("Stats:")
                        .font(.title.bold())
                        .padding(.vertical, 2)
                    ) {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "cart.fill")
                                Text("Number of orders: ")
                                Text("\(orders.count)")
                                    .bold()
                            }
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                Text("Tipped drivers: ")
                                Text("\(tippedDrivers) Kč")
                                    .bold()
                            }
                            HStack {
                                Image(systemName: "banknote.fill")
                                Text("Money spent: ")
                                Text("\(moneySpend) Kč")
                                    .bold()
                            }
                        }
                        .padding(.vertical, 5)
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
                                }
                                .padding(.horizontal, 30)
                            }
                    ) {
                        ForEach(orders) { order in
                            NavigationLink(destination: OrderHistoryDetailView(order: order)) {
                                OrderListView(order: order)
                            }
                        }
                    }
                }
                .task {
                    await loadOrders()
                }
                .refreshable {
                    await loadOrders()
                }
                .navigationTitle("Orders history")
            }
        }
    }
    
    private func loadOrders() async {
        do {
            orders = try await NetworkManager.shared.getOrders().data
        } catch {
            print(" Failed to load orders:", error)
        }
    }
}

#Preview {
    OrderHistoryView()
}
