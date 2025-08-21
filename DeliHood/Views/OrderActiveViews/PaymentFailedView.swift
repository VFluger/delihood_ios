//
//  PaymentFailedView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.08.2025.
//

import SwiftUI

struct PaymentFailedView: View {
    var error: Error
    
    @EnvironmentObject var orderStore: OrderStore
    @EnvironmentObject var paymentManager: PaymentSheetManager
    
    @State private var clientSecret: String = ""
    
    @State private var alertItem: AlertItem?
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundStyle(.red)
                .padding()
            Text("Payment Failed")
                .font(.title)
                .fontWeight(.semibold)
            Text("Your payment for the order failed. \nPlease try again.")
                .multilineTextAlignment(.center)
                .padding()
            Text("Total: \(orderStore.currentOrder?.totalPrice ?? 0)")
            Button {
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
                clientSecret = try await NetworkManager.shared.getPaymentSecret(orderId: orderId)
                try await orderStore.updateStatus()
            }
        }
        .alert(item: $alertItem) {alert in
            Alert(title: Text(alert.title), message: Text(alert.message))
        }
    }
}

#Preview {
    PaymentFailedView(error: URLError(.badServerResponse))
}
