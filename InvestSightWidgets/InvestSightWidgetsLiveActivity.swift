//
//  InvestSightWidgetsLiveActivity.swift
//  InvestSightWidgets
//
//  Created by Tiago Afonso on 02/11/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct InvestSightWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct InvestSightWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: InvestSightWidgetsAttributes.self) { context in
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

extension InvestSightWidgetsAttributes {
    fileprivate static var preview: InvestSightWidgetsAttributes {
        InvestSightWidgetsAttributes(name: "World")
    }
}

extension InvestSightWidgetsAttributes.ContentState {
    fileprivate static var smiley: InvestSightWidgetsAttributes.ContentState {
        InvestSightWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: InvestSightWidgetsAttributes.ContentState {
         InvestSightWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: InvestSightWidgetsAttributes.preview) {
   InvestSightWidgetsLiveActivity()
} contentStates: {
    InvestSightWidgetsAttributes.ContentState.smiley
    InvestSightWidgetsAttributes.ContentState.starEyes
}
