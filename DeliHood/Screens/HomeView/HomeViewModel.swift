//
//  HomeViewModel.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedFilter: CategoryContext? = nil
    @Published var alertItem: AlertItem? = nil
    
    @AppStorage("order") var orderData: Data?
    
    @Published var mainScreenData: [Cook]? = nil
    
    @Published var isLoading = false
    
    func getData() {
        isLoading = true
        Task {
            do {
                mainScreenData = try await NetworkManager.shared.getMainScreen().data
                    //Order exists, filter only the cook thats with the same id
                    do {
                        let order = try JSONDecoder().decode(Order.self, from: orderData ?? Data())
                        mainScreenData = mainScreenData?.filter { $0.id == order.cookId }
                    }catch {
                        print("Order decoding failed, prolly no order")
                    }
                isLoading = false
            }catch {
                print(error)
                alertItem = AlertContext.cannotGetData
                isLoading = false
            }
        }
    }
}
