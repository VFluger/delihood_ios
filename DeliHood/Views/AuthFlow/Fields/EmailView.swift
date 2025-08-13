//
//  EmailView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

struct EmailView: View {
    @Binding var text: String
    var isEmailValid: Bool?
    
    var body: some View {
        TextField("Email Address", text: $text)
            .brandStyle(isFieldValid: isEmailValid != nil ? isEmailValid! : true)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
    }
}

#Preview {
    EmailView(text: .constant(""))
}
