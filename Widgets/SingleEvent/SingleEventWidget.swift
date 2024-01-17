import Foundation
import WidgetKit
import SwiftUI

struct SingleEventWidget: Widget {
    let kind: String = "com.clouddroid.DaysCounter.SingleEvent"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: SingleEventProvider()
        ) { entry in
            SingleEventView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Single event")
        .description("Shows a counter for a single event.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

struct SingleEventView : View {
    var entry: SingleEventProvider.Entry
    
    @Environment(\.widgetContentMargins) var margins
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer(minLength: 0)
                    CounterStacks()
                }
                Spacer()
                HStack {
                    VStack(
                        alignment: .leading,
                        spacing: 5
                    ) {
                        Text("Holidays")
                            .font(family == .systemMedium ? .title3 : .body)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        Text("June 17, 2025")
                            .font(family == .systemMedium ? .footnote : .caption)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }
                    Spacer(minLength: 0)
                }
            }
            .padding(margins)
            .background {
                Image(uiImage: UIImage(named: "nature8.jpg")!)
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        Color(UIColor.black)
                            .opacity(0.2)
                    }
            }
        }
    }
}

private struct CounterStacks: View {
    var body: some View {
        HStack {
            CounterStack(number: "15", label: "days")
        }
        .foregroundStyle(.white)
    }
}

private struct CounterStack: View {
    let number: String
    let label: String
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack {
            Text(number)
                .font(family == .systemMedium ? .title : .title2)
                .fontWeight(.heavy)
            Text(label)
                .font(family == .systemMedium ? .subheadline : .footnote)
        }
        .lineLimit(1)
    }
}

#Preview(as: .systemSmall) {
    SingleEventWidget()
} timeline: {
    SingleEventEntry(date: .now, emoji: "😀")
}

#Preview(as: .systemMedium) {
    SingleEventWidget()
} timeline: {
    SingleEventEntry(date: .now, emoji: "😀")
}
