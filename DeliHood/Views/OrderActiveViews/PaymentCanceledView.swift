//
//  PaymentCanceledView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.08.2025.
//

import SwiftUI

struct PaymentCanceledView: View {
    @EnvironmentObject var orderStore: OrderStore
    @EnvironmentObject var paymentManager: PaymentSheetManager
    
    @State private var clientSecret: String = ""
    @State private var alertItem: AlertItem?
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundStyle(.yellow)
                .padding()
            Text("Payment Canceled")
                .font(.title)
                .fontWeight(.semibold)
            Text("Your payment for the order was canceled. \nPlease try again.")
                .multilineTextAlignment(.center)
                .padding()
            Button {
                print(clientSecret)
                paymentManager.configure(with: clientSecret)
                paymentManager.present(orderStore: orderStore, order: orderStore.currentOrder!)
            }label: {
                BrandBtn(text: "Try again", width: 325)
            }
            Button {
                Task {
                    do {
                        try await orderStore.cancelCurrentOrder()
                        try await orderStore.updateStatus()
                    }catch {
                        alertItem = AlertContext.cannotCancel
                    }
                }
            }label: {
                Label("Cancel order", systemImage: "xmark.app")
                    .frame(width: 325)
                    .padding()
                    .foregroundStyle(Color.label)
                    .glassEffect(.regular.interactive())
            }
            .padding()
        }.onAppear {
            guard let orderId = orderStore.currentOrder?.serverId else {
                alertItem = AlertContext.cannotGetPaymentData
                return
            }
            Task {
                do {
                    clientSecret = try await NetworkManager.shared.getPaymentSecret(orderId: orderId)
                    try await orderStore.updateStatus()
                }catch {
                    print(error)
                }
            }
        }
        .alert(item: $alertItem) {alert in
            Alert(title: Text(alert.title), message: Text(alert.message))
        }
    }
}

#Preview {
    PaymentCanceledView()
}
