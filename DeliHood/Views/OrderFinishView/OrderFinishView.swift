//
//  OrderFinishView().swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import SwiftUI
import SwiftData

struct OrderFinishView: View {
    @AppStorage("order") var orderData: Data?
    
    @Query var locationModels: [Location]
    
    @Environment(\.modelContext) var context
    
    @StateObject var vm = OrderFinishViewModel()
    @EnvironmentObject var paymentManager: PaymentSheetManager
    @EnvironmentObject var orderStore: OrderStore
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    Text("Items:")
                        .font(.title2).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                    
                    ForEach($vm.order.items) { $orderItem in
                        OrderItemListView(orderItem: $orderItem, order: $vm.order)
                    }
                    
                    Text("Delivery address:")
                        .font(.title2).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                        .padding(.horizontal)
                    Text("Select where you want your order delivered")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(locationModels.enumerated()), id: \.element.id) { index, location in
                            LocationOrderListWithBtnsView(location: location, index: index, totalCount: locationModels.count, vm: vm)
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                    Label("Add a new address", systemImage: "plus")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .foregroundStyle(Color.label)
                        .glassEffect(.regular.interactive())
                        .padding()
                        .onTapGesture {
                            vm.isShowingAddAddressSheet = true
                        }
                    
                    Text("Tip:")
                        .font(.title2).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                        .padding(.horizontal)
                    Text("Optional tip for delivery driver")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    HStack {
                        TextField("0", text: $vm.tip)
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                        .padding(8)
                        //Check if valid
                        .onChange(of: vm.tip, perform: vm.validateTip)
                        Text("Kč")
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                        .frame(height: 50)
                }
                VStack(spacing: 12) {
                    HStack {
                        Text("Items total:")
                        Spacer()
                        Text("\(vm.itemsTotal) Kč")
                    }
                    HStack {
                        Text("Delivery fee:")
                        Spacer()
                        Text("30 Kč")
                    }
                    HStack {
                        Text("Tip:")
                        Spacer()
                        Text("\(vm.order.tip) Kč")
                    }
                    Divider()
                    HStack {
                        Text("Total:")
                        Spacer()
                        Text("\(vm.total) Kč")
                    }
                    .fontWeight(.bold)
                    
                    Button{
                        Task {
                            do {
                                let resp = try await NetworkManager.shared.postOrder(vm.order)
                                //set orderId from server
                                vm.order.serverId = resp.orderId
                                vm.order.status = .pending
                                
                                paymentManager.configure(with: resp.clientSecret)
                                paymentManager.present(orderStore: orderStore, order: vm.order)
                            }
                        }
                    }label: {
                        Text("Order")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .glassEffect(
                                .regular
                                .tint(.brand.opacity(0.5))
                                .interactive()
                            )
                    }
                }
                .padding()
                .background(.popup)
            }
            .loadingOverlay(vm.isLoading)
            .onAppear {
                vm.decodeOrder(orderData: orderData)
            }
            .sheet(item: $vm.showUpdateSheet) { location in
                UpdateAddressView(locationModel: location)
                    .presentationDetents([.height(600)])
            }
            .sheet(isPresented: $vm.isShowingAddAddressSheet) {
                AddLocationView()
                    .presentationDetents([.height(600)])
            }
            .alert(item: $vm.alertItem) {alert in
                Alert(title: Text(alert.title), message: Text(alert.description))
            }
            .navigationTitle("Order")
        }
    }
}

struct OrderItemListView: View {
    
    @Binding var orderItem: OrderItem
    @Binding var order: Order
    
    @AppStorage("order") var orderData: Data?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FoodListView(food: orderItem.food, cook: order.cook!)
                .padding(.bottom, 8)
            HStack(alignment: .center, spacing: 16) {
                QuantityBtn(quantity: $orderItem.quantity) { quantity in
                    if quantity == 0 {
                        //Remove item from order
                        order.items.removeAll(where: { $0.id == orderItem.id })
                        if order.items.count == 0 {
                            orderData = Data()
                        }
                    }
                    orderData = try? JSONEncoder().encode(order)
                    order = try! JSONDecoder().decode(Order.self, from: orderData!)
                    
                }
                Spacer()
                    .frame(width: 10)
                Text("\(orderItem.food.price * orderItem.quantity) Kč")
                    .font(.title3.bold())
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(.brand)
            }
        }
        .padding(10)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
    }
}

struct LocationOrderListView: View {
    @Binding var selectedLocation: Location?
    var location: Location
    @Binding var order: Order
    
    var body: some View {
        Label(location.address, systemImage: selectedLocation == location ? "checkmark.circle.fill" : "circle")
            .onTapGesture {
                withAnimation {
                    if selectedLocation == location {
                        selectedLocation = nil
                        order.deliveryLocationLat = nil
                        order.deliveryLocationLng = nil
                        return
                    }
                    selectedLocation = location
                    order.deliveryLocationLat = location.locationLat
                    order.deliveryLocationLng = location.locationLng
                }
            }
    }
}

struct LocationOrderListWithBtnsView: View {
    var location: Location
    var index: Int
    var totalCount: Int
    
    @Environment(\.modelContext) var context
    
    @ObservedObject var vm: OrderFinishViewModel
    
    var body: some View {
        HStack {
            LocationOrderListView(selectedLocation: $vm.selectedLocation, location: location, order: $vm.order)
            Spacer()
            Button(action: { vm.showUpdateSheet = location }) {
                Image(systemName: "pencil")
            }
            .tint(.blue)
            .frame(width: 30, height: 30)
            .clipShape(Circle())
            .buttonStyle(.glass)
            Button(action: {
                withAnimation {
                    vm.deleteLocation(location, context: context)
                }
            }) {
                Image(systemName: "trash")
            }
            .tint(.red)
            .frame(width: 30, height: 30)
            .clipShape(Circle())
            .buttonStyle(.glass)
        }
        .padding()
        
        if index < totalCount - 1 {
            Divider()
        }
    }
}

#Preview {
    OrderItemListView(orderItem: .constant(MockData.order.items.first!), order: .constant(MockData.order))
}
