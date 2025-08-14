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
}
