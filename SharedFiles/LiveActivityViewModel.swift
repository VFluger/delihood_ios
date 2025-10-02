//
//  LiveActivityViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.09.2025.
//
import Foundation
import SwiftUI
import ActivityKit

@Observable
class LiveActivityViewModel {
    var orderStatus: String = ""
    var orderId: Int = -1
    var orderActivity: Activity<OrderAttributes>? = nil

        func startLiveActivity() {
            if orderStatus.isEmpty { return }
            if orderId == -1 { return }
            
            let attributes = OrderAttributes(orderId: orderId)
            let initialState = OrderAttributes.ContentState(
                status: orderStatus
            )
            do {
                orderActivity = try Activity.request(attributes: attributes, content: ActivityContent(state: initialState, staleDate: nil))
            }catch {
                print("Error creating activity")
            }
        }

        func updateLiveActivity() {
            if orderId == -1 { return }
            
            let updatedState = OrderAttributes.ContentState(
                status: orderStatus
            )
            Task {
                await orderActivity?.update(using: updatedState)
            }
        }

        func endLiveActivity(success: Bool = false) {
            
            let finalState = OrderAttributes.ContentState(
                status: "delivered"
            )
            
            Task {
                await orderActivity?.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .default)
            }
        }
}
