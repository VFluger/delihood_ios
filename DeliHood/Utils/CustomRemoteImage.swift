//
//  DHRemoteImage.swift
//  DeliHood
//
//  Created by Vojta Fluger on 15.08.2025.
//

import SwiftUI
import RemoteImage

struct CustomRemoteImage: View {
    var UrlString: String?

    let placeholderView: () -> AnyView

    init(UrlString: String? = nil, @ViewBuilder placeholderView: @escaping () -> some View) {
        self.UrlString = UrlString
        self.placeholderView = { AnyView(placeholderView()) }
    }

    var body: some View {
        RemoteImage(type: .url((URL(string: UrlString ?? "") ?? URL(string: "https://error.com/error.jpg"))!), errorView: { _ in
            placeholderView()
        }, imageView: { image in
            image
                .resizable()
                .scaledToFill()
                .clipped()
        }, loadingView: {
            placeholderView()
        })
    }
}

#Preview {
    CustomRemoteImage(placeholderView: {
        Image("food-placeholder")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(.primary)
            .frame(width: 50)
    })
}
