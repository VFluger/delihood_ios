//
//  CategoryView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 16.08.2025.
//

import SwiftUI

struct CategoryView: View {
    var category: CategoryContext? = nil
    var string: String?
    
    
    var body: some View {
        if category != nil {
            HStack {
                Image(category!.iconName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.primary)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(category!.name)
            }
        }
        if string != nil {
            if let categoryEnum = CategoryContext(rawValue: string!) {
                HStack {
                    Image(categoryEnum.iconName)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.primary)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text(categoryEnum.name)
                }
            }
        }
    }
}

#Preview {
    CategoryView(category: CategoryContext.asian)
    CategoryView(string: "italien")
}
