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
    
    @Published var mainScreenData: [Cook]? = nil
    
    @Published var isLoading = false
    
    func getData() {
        isLoading = true
        Task {
            do {
                mainScreenData = try await NetworkManager.shared.getMainScreen().data
                isLoading = false
            }catch {
                print(error)
                alertItem = AlertContext.cannotGetData
                isLoading = false
            }
        }
    }
}
