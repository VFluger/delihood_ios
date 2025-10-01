//
//  DeliHoodWidgetsLiveActivity.swift
//  DeliHoodWidgets
//
//  Created by Vojta Fluger on 17.09.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DeliHoodWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DeliHoodWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliHoodWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DeliHoodWidgetsAttributes {
    fileprivate static var preview: DeliHoodWidgetsAttributes {
        DeliHoodWidgetsAttributes(name: "World")
    }
}

extension DeliHoodWidgetsAttributes.ContentState {
    fileprivate static var smiley: DeliHoodWidgetsAttributes.ContentState {
        DeliHoodWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DeliHoodWidgetsAttributes.ContentState {
         DeliHoodWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DeliHoodWidgetsAttributes.preview) {
   DeliHoodWidgetsLiveActivity()
} contentStates: {
    DeliHoodWidgetsAttributes.ContentState.smiley
    DeliHoodWidgetsAttributes.ContentState.starEyes
}
