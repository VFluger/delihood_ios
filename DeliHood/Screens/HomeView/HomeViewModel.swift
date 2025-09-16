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
    @Published var isError = false
    
    
    func getData(lat: Double?, lng: Double?) {
        isLoading = true
        Task {
            do {
                if lat == nil || lng == nil {
                    isError = true
                    isLoading = false
                    alertItem = AlertContext.noLocation
                    return
                }
                //Get data from backend
                mainScreenData = try await NetworkManager.shared.getMainScreen(lat: lat!, lng: lng!).data
                if let data = orderData {
                    do {
                        //Order exists, decode and filter only food from the same cook
                        let order = try JSONDecoder().decode(Order.self, from: data)
                        if order.items.isEmpty {
                            orderData = Data()
                        }
                        isError = false
                        mainScreenData = mainScreenData?.filter { $0.id == order.cook?.id }
                    }catch {
                        print("Decoding failed")
                        //Order decode failed, probably no order initiated
                        //Just returns the mainScreenData
                    }
                }
                isError = false
                isLoading = false
            }catch {
                alertItem = AlertContext.cannotGetData
                isError = true
                isLoading = false
            }
        }
    }
}
