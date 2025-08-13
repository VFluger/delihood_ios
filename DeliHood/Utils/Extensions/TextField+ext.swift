//
//  TextField+ext.swift
//  DeliHood
//
//  Created by Vojta Fluger on 12.08.2025.
//

import SwiftUI

extension TextField {
    func brandStyle(isFieldValid: Bool) -> some View {
        self.frame(width: 325)
            .padding()
            .background(isFieldValid ? .brand.opacity(0.2) : .red.opacity(0.1) )
            .clipShape(Capsule())
            .glassEffect(.regular.interactive())
    }
}

extension SecureField {
    func brandStyle(isFieldValid: Bool) -> some View {
        self.frame(width: 325)
            .padding()
            .background(isFieldValid ? .brand.opacity(0.2) : .red.opacity(0.1) )
            .clipShape(Capsule())
            .glassEffect(.regular.interactive())
    }
}
