//
//  CheckboxView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 16.08.2025.
//

import SwiftUI

struct CheckboxView: View {
    @Binding var isChecked: Bool
    let text: String
    
    var body: some View {
            Label(text, systemImage: isChecked ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(isChecked ? .brand : .primary)
            .onTapGesture {
                withAnimation {
                    isChecked.toggle()
                }
            }
    }
}

#Preview {
    @Previewable @State var isChecked = false
    CheckboxView(isChecked: $isChecked, text: "Checkbox")
}
