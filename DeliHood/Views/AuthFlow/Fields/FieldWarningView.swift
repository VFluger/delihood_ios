//
//  FieldWarningView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

struct FieldWarningView: View {
    var isFieldValid: Bool
    var warningText: String
    
    var body: some View {
        if !isFieldValid {
            HStack {
                Label(warningText, systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.red)
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                    .padding(.horizontal, 30)
                Spacer()
            }
        }else {
            Spacer()
                .frame(height: 20)
        }
    }
}

#Preview {
    FieldWarningView(isFieldValid: false, warningText: "This field is not valid")
}
