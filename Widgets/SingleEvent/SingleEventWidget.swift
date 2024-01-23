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
                    CounterStacks(entry: entry)
                }
                Spacer()
                HStack {
                    VStack(
                        alignment: .leading,
                        spacing: 5
                    ) {
                        Text(entry.data.name)
                            .font(
                                .custom(
                                    entry.data.fontType,
                                    size: family == .systemMedium ? 20 : 17,
                                    relativeTo: family == .systemMedium ? .title3 : .body
                                )
                            )
                            .fontWeight(.bold)
                        Text(entry.data.eventDate.formatted(date: .abbreviated, time: .omitted))
                            .font(
                                .custom(
                                    entry.data.fontType,
                                    size: family == .systemMedium ? 13 : 12,
                                    relativeTo: family == .systemMedium ? .footnote : .caption
                                )
                            )
                            .lineLimit(1)
                    }
                    .foregroundStyle(Color(uiColor: entry.data.fontColor))
                    
                    Spacer(minLength: 0)
                }
            }
            .padding(margins)
            .background {
                Image(uiImage: entry.data.image)
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        Color(UIColor.black)
                            .opacity(entry.data.imageDim)
                    }
            }
        }
    }
}

private struct CounterStacks: View {
    let entry: SingleEventProvider.Entry
    
    var body: some View {
        HStack {
            if let years = entry.data.dateComponents.years {
                CounterStack(number: years, label: "years", entry: entry)
            }
            if let months = entry.data.dateComponents.months {
                CounterStack(number: months, label: "months", entry: entry)
            }
            if let weeks = entry.data.dateComponents.weeks {
                CounterStack(number: weeks, label: "weeks", entry: entry)
            }
            if let days = entry.data.dateComponents.days {
                CounterStack(number: days, label: "days", entry: entry)
            }
        }
    }
}

private struct CounterStack: View {
    let number: Int
    let label: String
    
    let entry: SingleEventProvider.Entry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack {
            Text(String(number))
                .font(
                    .custom(
                        entry.data.fontType,
                        size: family == .systemMedium ? 28 : 22,
                        relativeTo: family == .systemMedium ? .title : .title2
                    )
                )
                .fontWeight(.heavy)
            Text(label)
                .font(
                    .custom(
                        entry.data.fontType,
                        size: family == .systemMedium ? 15 : 13,
                        relativeTo: family == .systemMedium ? .subheadline : .footnote
                    )
                )
        }
        .foregroundStyle(Color(uiColor: entry.data.fontColor))
        .lineLimit(1)
    }
}

#Preview(as: .systemSmall) {
    SingleEventWidget()
} timeline: {
    SingleEventEntry(date: .now, data: .sample)
}

#Preview(as: .systemMedium) {
    SingleEventWidget()
} timeline: {
    SingleEventEntry(date: .now, data: .sample)
}
