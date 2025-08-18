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
    
    @Published var showAccount = false   // track navigation state
    @Published var isOrderPresented = false // Show finish order view sheet
    
    @AppStorage("order") var orderData: Data?
    
    @Published var mainScreenData: [Cook]? = nil //Array to display cooks and food
    
    @Published var isLoading = false
    
    func getData() {
        isLoading = true
        Task {
            do {
                //Get data from backend
                mainScreenData = try await NetworkManager.shared.getMainScreen().data
                if let data = orderData {
                    do {
                        //Order exists, decode and filter only food from the same cook
                        let order = try JSONDecoder().decode(Order.self, from: data)
                        mainScreenData = mainScreenData?.filter { $0.id == order.cookId }
                    }catch {
                        //Order decode failed, probably no order initiated
                        //Just returns the mainScreenData
                    }
                }
                isLoading = false
            }catch {
                alertItem = AlertContext.cannotGetData
                isLoading = false
            }
        }
    }
}
