//
//  dismissXBtn.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI

struct dismissXBtn: View {
    var body: some View {
        Image(systemName: "xmark")
            .frame(width: 20, height: 20)
            .foregroundStyle(Color.label)
            .padding()
            .glassEffect(
                .clear
                    .interactive()
            )
    }
}

#Preview {
    dismissXBtn()
}
