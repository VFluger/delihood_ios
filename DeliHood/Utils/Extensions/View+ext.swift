//
//  View+ext.swift
//  DeliHood
//
//  Created by Vojta Fluger on 13.08.2025.
//

import SwiftUI

extension View {
    func brandGlassEffect(interactive: Bool? = nil) -> some View {
        self
        .glassEffect(
            .regular
                .tint(.brand.opacity(0.3))
                .interactive(interactive ?? false)
        )
    }
    func loadingOverlay(_ isLoading: Bool) -> some View {
        self
            .blur(radius: isLoading ? 20 : 0)
            .overlay {
                if isLoading {
                    LoadingOverlayView()
                }
            }
    }
    func noConnectionOverlay(_ show: Binding<Bool>, retryFnc: @escaping () async -> Void) -> some View {
        self
            .fullScreenCover(isPresented: show) {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    NoConnectionOverlayView(show: show, retryFnc: retryFnc)
                        .transition(.move(edge: .bottom))
                }
            }
    }
}
