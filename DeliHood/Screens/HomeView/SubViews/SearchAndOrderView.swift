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
    
    var body: some View {
        VStack {
            HStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(CategoryContext.allCases, id: \.self) {data in
                            HStack {
                                Image(data.iconName)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.secondary)
                                    .frame(width: 15)
                                    .scaledToFit()
                                Text(data.name)
                                    .foregroundStyle(.secondary)
                                    .brightness(0.2)
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
                    .onSubmit {
                        //SEARCH
                    }
            }
            .frame(width: 325)
            .foregroundStyle(.secondary)
            .padding()
            .glassEffect(.regular.interactive())
        }
    }
}

#Preview {
    @Previewable @State var selectedFilter: CategoryContext? = nil
    
    Text(selectedFilter?.name ?? "")
    SearchAndOrderView(selectedFilter: $selectedFilter, searchText: .constant(""))
}
