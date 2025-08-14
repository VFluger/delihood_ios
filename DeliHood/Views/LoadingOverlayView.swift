//
//  LoadingOverlayView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import SwiftUI

struct LoadingOverlayView: View {
    var body: some View {
            ProgressView()
                .scaleEffect(2)
    }
}

#Preview {
    LoadingOverlayView()
}
