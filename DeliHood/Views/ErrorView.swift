//
//  ErrorView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 15.08.2025.
//

import SwiftUI

//Could be replaced by ContentUnavailableView()
struct ErrorView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 90)
                .padding(25)
            
            Text("We're sorry, \nbut there has been an error.")
                .multilineTextAlignment(.center)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            Text("Please try to refresh the page")
                .padding(.bottom, 20)
                .padding(.top, 2)
            
            Text("If this problem persists, please contact our support.")
                .font(.footnote)
        }
    }
}

#Preview {
    ErrorView()
}
