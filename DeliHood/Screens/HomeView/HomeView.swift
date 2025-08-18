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
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        //If alert, show error view
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
            //Settings icon
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.showAccount = true
                    } label: {
                        CustomRemoteImage(UrlString: authStore.user?.imageUrl) {
                            Image(systemName: "person")
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
            //Open settings
            .navigationDestination(isPresented: $vm.showAccount) {
                AccountView()
            }
            
            // only show overlay when NOT in account
            .overlay {
                if !vm.showAccount {
                    VStack {
                        Spacer()
                        //Search and categorys + finish order btn
                        SearchAndOrderView(selectedFilter: $vm.selectedFilter,
                                           searchText: $vm.searchText, isOrderPresented: $vm.isOrderPresented)
                        .padding()
                        //Fade on the bottom
                        .background(Gradient(colors: [.clear, .black.opacity(0.5)]))
                    }
                }
            }
            .onAppear { vm.getData() }
            .sheet(isPresented: $vm.isOrderPresented) {
                OrderFinishView()
            }
            //If order in AppStorage changes, get again (filters the cooks)
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
