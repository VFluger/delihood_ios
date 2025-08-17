//
//  BrandBtn.swift
//  DeliHood
//
//  Created by Vojta Fluger on 12.08.2025.
//

import SwiftUI

struct BrandBtn: View {
    var text: String
    var disabled: Bool = false
    var width: CGFloat?
    
    var body: some View {
        Text(text)
            .foregroundStyle(Color.label.opacity(disabled ? 0.5 : 1))
            .fontWeight(.semibold)
            .frame(minWidth: width ?? 50, minHeight: 20)
            .padding()
            .glassEffect(
                .regular
                    .tint(disabled ? .brand.opacity(0.2) : .brand.opacity(0.4))
                    .interactive(!disabled)
            )
    }
}

struct BrandIconBtn: View {
    var imageName: String
    var disabled: Bool = false
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.label.opacity(disabled ? 0.5 : 1))
            .frame(width: 50, height: 20)
            .fontWeight(.semibold)
            .padding()
            .glassEffect(
                .regular
                    .tint(disabled ? .brand.opacity(0.2) : .brand.opacity(0.4))
                    .interactive(!disabled)
            )
    }
}

#Preview {
    BrandBtn(text: "Back", disabled: true)
    BrandIconBtn(imageName: "chevron.right")
}
