//
//  BadgesSheetView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 16.08.2025.
//

import SwiftUI

struct BadgesSheetView: View {
    @State private var selectedIndex: Int = 0
    
    let badges: [(imageName: String, color: Color)] = [("flame", .accentred), ("sparkles.2", .accentgreen), ("checkmark.seal.fill", .accentblue)]
    
    var body: some View {
        VStack {
            HStack {
                ForEach(badges.indices, id: \.self) { index in
                    VStack {
                        Image(systemName: badges[index].imageName)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .cornerRadius(8)
                            .foregroundStyle(badges[index].color)
                            .onTapGesture {
                                withAnimation {
                                    selectedIndex = index
                                }
                            }
                        
                        // underline only if selected
                        Rectangle()
                            .fill(selectedIndex == index ? badges[index].color : Color.clear)
                            .frame(height: 2)
                    }
                }
            }
            .padding()
            Spacer()
            // different page depending on selected card
                if selectedIndex == 0 {
                    BadgeDetailView(imageName: "flame", name: "Popular", description: "This cook is really popular and loved by local customers. Earned by having more then 10 orders in a week.", color: .accentred)
                } else if selectedIndex == 1 {
                    BadgeDetailView(imageName: "sparkles.2", name: "Quality", description: "This cook has exceptional quality and reviews for their food. Earned by high ratings and licenses.", color: .accentgreen)
                } else {
                    BadgeDetailView(imageName: "checkmark.seal.fill", name: "Verified account", description: "This account is verified with proper license and AI face matching for your safety.", color: .accentblue)
                }
            Spacer()
        }
    }
}

struct BadgeDetailView: View {
    let imageName: String
    let name: String
    let description: String
    let color: Color
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 90)
            .foregroundStyle(color)
        Text(name)
            .font(.largeTitle)
        Text(description)
            .multilineTextAlignment(.center)
            .padding()
    }
}

#Preview {
    BadgesSheetView()
}
