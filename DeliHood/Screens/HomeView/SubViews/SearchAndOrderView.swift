//
//  SearchAndOrderView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import SwiftUI

struct SearchAndOrderView: View {
    @Binding var selectedFilter: CategoryContext?
    @Binding var searchText: String
    @Binding var isOrderPresented: Bool
    
    @AppStorage("order") var orderData: Data?
    
    @State private var isShowingOrderBtn = false
    @Namespace private var animation
    
    private var order: Order? {
        guard let data = orderData else { return nil }
        return try? JSONDecoder().decode(Order.self, from: data)
    }
    
    var body: some View {
        VStack {
            HStack {
                //Category filters
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(CategoryContext.allCases, id: \.self) {data in
                            HStack {
                                Image(data.iconName)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(Color.label)
                                    .frame(width: 15)
                                    .scaledToFit()
                                Text(data.name)
                                    .foregroundStyle(Color.label)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .glassEffect(
                                .regular
                                    .tint(.brand.opacity(selectedFilter == data ? 0.3 : 0))
                                    .interactive())
                            .padding(.horizontal, 5)
                            .onTapGesture {
                                withAnimation(.easeOut) {
                                    //Toggle selectedFilter
                                    if selectedFilter == data {
                                        selectedFilter = nil
                                    }else {
                                        selectedFilter = data
                                    }
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.leading, 10)
                .padding(.bottom, 10)
            }
            if isShowingOrderBtn {
                //Finish order btn
                HStack {
                    Spacer()
                        .frame(width: 30)
                    Button {
                        withAnimation {
                            isOrderPresented = true
                        }
                    }label: {
                        Label("•  Finish order", systemImage: "\(order?.items.count ?? 0).circle")
                            .foregroundStyle(Color.label)
                            .fontWeight(.semibold)
                            .padding()
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                            .brandGlassEffect()
                    }
                    Spacer()
                        .frame(width: 30)
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.label)
                        .frame(width: 25)
                        .padding()
                        .glassEffect(.regular.interactive())
                        .matchedGeometryEffect(id: "searchField", in: animation)
                        .onTapGesture {
                            withAnimation {
                                isShowingOrderBtn = false
                            }
                        }
                    Spacer()
                }
                
            }else {
                //Search bar
                HStack {
                    if !(order?.items.isEmpty ?? true) {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.label)
                            .frame(width: 25, height: 25)
                            .padding()
                            .glassEffect(.regular.interactive())
                            .onTapGesture {
                                withAnimation {
                                    isShowingOrderBtn = true
                                }
                            }
                    }
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $searchText)
                            .foregroundStyle(.primary)
                        //Adding animation to the update of value
                            .onChange(of: searchText, { oldValue, newValue in
                                withAnimation(.easeInOut) {
                                    searchText = newValue
                                }
                            })
                            .opacity(isShowingOrderBtn ? 0 : 1)
                            .animation(.easeInOut, value: isShowingOrderBtn)
                    }
                    .matchedGeometryEffect(id: "searchField", in: animation)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.label)
                    .glassEffect(.regular.interactive())
                }
                
            }
        }
        .onChange(of: order?.items) {
            withAnimation {
                isShowingOrderBtn = !(order?.items.isEmpty ?? true)
            }
        }
        //When opening the app, check if show order btn
        .onAppear {
            withAnimation {
                isShowingOrderBtn = !(order?.items.isEmpty ?? true)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedFilter: CategoryContext? = nil
    
    Text(selectedFilter?.name ?? "")
    SearchAndOrderView(selectedFilter: $selectedFilter, searchText: .constant(""), isOrderPresented: .constant(false))
}
