//
//  HomeView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authStore: AuthStore
    
    @StateObject var vm = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                    ScrollView {
                        LazyVStack {
                            if vm.alertItem == nil {
                                ForEach(vm.mainScreenData ?? []) {cook in
                                    CookListView(cook: cook, selectedFilter: $vm.selectedFilter, searchText: $vm.searchText)
                                    
                                }
                            }else {
                                ErrorView()
                            }
                        }
                    }
                    .refreshable {
                        vm.getData()
                    }
                    Spacer()
                }
            .navigationTitle(vm.alertItem == nil ? "Home" : "Error")
        }
        .overlay {
            VStack {
                Spacer()
                SearchAndOrderView(selectedFilter: $vm.selectedFilter,
                                   searchText: $vm.searchText)
                .padding()
                .background(Gradient(colors: [.clear, .black.opacity(0.5)]))
            }
        }
        .onAppear { vm.getData() }
        .alert(item: $vm.alertItem) {alert in
            Alert(title: Text(alert.title), message: Text(alert.description), dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthStore())
}
