//
//  NoConnectionOverlayView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 14.08.2025.
//

import SwiftUI

struct NoConnectionOverlayView: View {
    @State var animate = true
    @Binding var show: Bool // bind from parent
    @State private var offsetY: CGFloat = 0
    
    var retryFnc: () async -> Void
    
    var body: some View {
        VStack {
            Spacer()
            //MARK: Card
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundStyle(.popup)
                    //MARK: Close btn
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.easeOut) {
                                    show.toggle()
                                }
                            }label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(Color(UIColor.label))
                                    .padding()
                                    .glassEffect(.clear.interactive())
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    //MARK: Main content of the card
                    VStack {
                        Spacer()
                        Text("No connection")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "wifi.slash")
                            .resizable()
                            .symbolEffect(.drawOn, isActive: animate)
                            .scaledToFit()
                            .frame(width: 100)
                        Spacer()
                        Text("Check your internet connection\n and try again.")
                            .multilineTextAlignment(.center)
                        Spacer()
                        Button {
                            Task {
                                await retryFnc()
                                withAnimation(.easeOut) {
                                    show = false
                                }
                            }
                        }label: {
                            BrandBtn(text: "Retry")
                        }
                        Spacer()
                    }
                }
            }
            .frame(height: 350)
            
            .padding(.bottom, 15)
            .padding(.horizontal, 5)
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.height > 0 { // only drag down
                            offsetY = gesture.translation.height
                        }
                    }
                    .onEnded { gesture in
                        if gesture.translation.height > 150 { // threshold
                            withAnimation(.spring()) {
                                show = false
                            }
                        } else {
                            withAnimation(.spring()) {
                                offsetY = 0
                            }
                        }
                    }
            )
            .onAppear {
                withAnimation(.linear(duration: 1.0)) {
                    animate.toggle()
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    @Previewable @State var show = true

    VStack {
        Button("Toggle") {
            withAnimation(.spring()) {
                show.toggle()
            }
        }
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .overlay(alignment: .bottom) {
        if show {
            ZStack {
                Color.black.opacity(0.5).ignoresSafeArea()
                NoConnectionOverlayView(show: $show) {
                    print("Calling api again")
                }
                    .transition(.move(edge: .bottom))
            }
        }
    }
}
