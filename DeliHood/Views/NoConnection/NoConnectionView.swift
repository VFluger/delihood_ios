//
//  NoConnectionView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import SwiftUI

struct NoConnectionView: View {
    @State var animateIcon: Bool = true
    
    var retryFnc: () async -> Void
    
    var body: some View {
        VStack {
            Text("No internet connection")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            Spacer()
                .frame(height: 100)
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .symbolEffect(.drawOn, isActive: animateIcon)
            Spacer()
                .frame(height: 50)
            Text("Check your internet connection\n and try again.")
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                Task {
                    await retryFnc()
                }
            }label: {
                BrandBtn(text: "Retry", width: 325)
            }
            .padding(.bottom, 40)
        }.onAppear {
            withAnimation(.easeOut) {
                animateIcon.toggle()
            }
        }
    }
}

#Preview {
    NoConnectionView() {
        print("Calling again api")
    }
}
