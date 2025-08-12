//
//  iOSCheckboxToggleStyle.swift
//  DeliHood
//
//  Created by Vojta Fluger on 12.08.2025.
//

import SwiftUI

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button(action: {

            // 2
            configuration.isOn.toggle()

        }, label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")

                configuration.label
            }
        })
    }
}
#Preview {
    @Previewable @State var isOn = false
    Toggle("Accept Terms and Conditions", isOn: $isOn)
        .toggleStyle(iOSCheckboxToggleStyle())
}
