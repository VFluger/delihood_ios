//
//  OrderFinishViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.08.2025.
//

import SwiftUI
import SwiftData

@MainActor
final class OrderFinishViewModel: ObservableObject {
    
    @Published var order = MockData.order
    
    @Published var selectedLocation: Location?
    
    @Published var showUpdateSheet: Location?
    @Published var isShowingAddAddressSheet = false
    
    @Published var tip: String = ""
    
    @Published var alertItem: AlertItem?
    
    @Published var isLoading = false
    
    func decodeOrder(orderData: Data?) {
        if let orderData {
            order = try! JSONDecoder().decode(Order.self, from: orderData)
        }
    }
    
    func deleteLocation(_ location: Location, context: ModelContext) {
        context.delete(location)
    }
    
    let deliveryFee = 30 // For this demo only a static value
    
    var itemsTotal: Int {
        order.items.reduce(0) { $0 + $1.food.price * $1.quantity }
    }
    
    var total: Int {
        itemsTotal + Int(order.tip) + deliveryFee
    }
    
    var canProceed: Bool {
        order.deliveryLocationLat != nil && order.deliveryLocationLng != nil && !order.items.isEmpty
    }
    
    func sendOrder(paymentManager: PaymentSheetManager, orderStore: OrderStore) {
        if !canProceed {
            alertItem = AlertContext.cannotProceedOrder
            return
        }
        Task {
            do {
                let resp = try await NetworkManager.shared.postOrder(order)
                //set orderId from server
                order.serverId = resp.orderId
                order.status = .pending
                
                paymentManager.configure(with: resp.clientSecret)
                paymentManager.present(orderStore: orderStore, order: order)
            }catch {
                print(error)
                alertItem = AlertContext.cannotSendOrder
            }
        }
    }
    
    func validateTip( newValue: String) {
            //Has to be int, not less than 0 and not more than 100
            if let intTip = Int(newValue), (0...100).contains(intTip) {
                tip = newValue
                order.tip = intTip
                //Check if empty, set to 0
            }else if newValue == "" {
                tip = newValue
                order.tip = 0
                //Dont allow
            }else {
                tip = tip
            }
    }
    
}
