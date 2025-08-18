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
    @State private var showAccount = false   // track navigation state
    @State private var isOrderPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        if vm.alertItem == nil {
                            ForEach(vm.mainScreenData ?? []) { cook in
                                CookListView(cook: cook,
                                             selectedFilter: $vm.selectedFilter,
                                             searchText: $vm.searchText)
                            }
                        } else {
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAccount = true
                    } label: {
                        CustomRemoteImage(UrlString: authStore.user?.imageUrl) {
                            Image(systemName: "person")
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showAccount) {
                AccountView()
            }
            
            // only show overlay when NOT in account
            .overlay {
                if !showAccount {
                    VStack {
                        Spacer()
                        SearchAndOrderView(selectedFilter: $vm.selectedFilter,
                                           searchText: $vm.searchText, isOrderPresented: $isOrderPresented)
                        .padding()
                        .background(Gradient(colors: [.clear, .black.opacity(0.5)]))
                    }
                }
            }
            .onAppear { vm.getData() }
            .sheet(isPresented: $isOrderPresented) {
                OrderFinishView()
            }
            .onChange(of: vm.orderData) {
                            vm.getData()
                        }
            .alert(item: $vm.alertItem) { alert in
                Alert(title: Text(alert.title),
                      message: Text(alert.description),
                      dismissButton: .default(Text("Ok")))
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthStore())
}
