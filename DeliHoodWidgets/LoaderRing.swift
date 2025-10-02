//
//  LoaderRing.swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.09.2025.
//
import SwiftUI

struct LoaderRing: View {
    var progress: Double // 0.0 – 1.0
    var color: Color = .green
    
    var body: some View {
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90)) // start from top
                .animation(.easeInOut, value: progress)
                .frame(width: 23, height: 23)
    }
}

#Preview {
    LoaderRing(progress: 0.5)
}
