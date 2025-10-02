//
//  DeliHoodWidgetsLiveActivity.swift
//  DeliHoodWidgets
//
//  Created by Vojta Fluger on 17.09.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DeliHoodWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderAttributes.self) { context in
            VStack {
                Text("Delihood")
                    .bold()
                    .foregroundStyle(.brand)
                    .padding(.top, 10)
                HStack {
                    VStack {
                        Text(HeadingStatus(from: context.state.status)?.rawValue ?? "Error")
                            .font(.title3.bold())
                            .padding(.bottom, 2)
                        
                        Text(DescStatus(from: context.state.status)?.rawValue ?? "Please open the app")
                            .font(.caption)
                            .frame(width: 150)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 150)
                    .padding()
                    Spacer()
                    ZStack {
                        ZStack {
                            Circle()
                                .stroke(.popup, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                            LoaderRing(progress: ProgressStatus(from: context.state.status)?.rawValue ?? 0, color: .brand)
                                .scaleEffect(3)
                        }
                        .frame(width: 69, height: 69)
                        VStack {
                            Text("\(EtaStatus(from: context.state.status)?.rawValue ?? 30)m")
                                .font(.title2.bold())
                                .foregroundStyle(.brand)
                                .padding(.trailing)
                                .offset(x: 8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.trailing, 10)
                }
            }

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Delihood")
                        .bold()
                        .foregroundStyle(.brand)
                        .padding(10)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    ZStack {
                        Circle()
                            .stroke(.popup, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        LoaderRing(progress: ProgressStatus(from: context.state.status)?.rawValue ?? 0, color: .brand)
                    }
                    .frame(width: 23, height: 23)
                    .padding(10)
                    
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        VStack {
                            Text(HeadingStatus(from: context.state.status)?.rawValue ?? "Error")
                                .font(.title3)
                                .padding(.bottom, 2)
                            Text(DescStatus(from: context.state.status)?.rawValue ?? "Please open the app")
                                .font(.caption)
                                .lineLimit(2)
                                .frame(width: 150)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 150)
                        .padding(.leading)
                        Spacer()
                        Text("\(EtaStatus(from: context.state.status)?.rawValue ?? 30)min")
                            .font(.title.bold())
                            .foregroundStyle(.brand)
                            .padding(.trailing, 10)
                    }
                }
            } compactLeading: {
                Text("\(EtaStatus(from: context.state.status)?.rawValue ?? 30)min")
                    .bold()
                    .foregroundStyle(.brand)
                    .padding(5)
                    .padding(.leading, 5)
            } compactTrailing: {
                ZStack {
                    Circle()
                        .stroke(.popup, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    LoaderRing(progress: ProgressStatus(from: context.state.status)?.rawValue ?? 0, color: .brand)
                }
                .padding(5)
            } minimal: {
                ZStack {
                    Text("D")
                        .bold()
                        .lineLimit(1)
                        .foregroundStyle(.brand)
                    LoaderRing(progress: ProgressStatus(from: context.state.status)?.rawValue ?? 0, color: .brand)
                }
            }
            .keylineTint(Color.red)
        }
    }
}

extension OrderAttributes {
    fileprivate static var preview: OrderAttributes {
        OrderAttributes(orderId: 1)
    }
}


#Preview("Notification", as: .content, using: OrderAttributes.preview) {
   DeliHoodWidgetsLiveActivity()
} contentStates: {
    OrderAttributes.ContentState(status: "waiting_for_pickup")
    OrderAttributes.ContentState(status: "delivered")
}


#Preview("DI min", as: .dynamicIsland(.minimal), using: OrderAttributes.preview) {
   DeliHoodWidgetsLiveActivity()
} contentStates: {
    OrderAttributes.ContentState(status: "delivering")
    OrderAttributes.ContentState(status: "waiting_for_pickup")
}

#Preview("DI comp", as: .dynamicIsland(.compact), using: OrderAttributes.preview) {
   DeliHoodWidgetsLiveActivity()
} contentStates: {
    OrderAttributes.ContentState(status: "waiting_for_pickup")
    OrderAttributes.ContentState(status: "delivering")
}

#Preview("DI exp", as: .dynamicIsland(.expanded), using: OrderAttributes.preview) {
   DeliHoodWidgetsLiveActivity()
} contentStates: {
    OrderAttributes.ContentState(status: "waiting_for_pickup")
    OrderAttributes.ContentState(status: "delivering")
}
