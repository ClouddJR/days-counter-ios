import Foundation
import WidgetKit
import SwiftUI

struct SingleEventWidget: Widget {
    let kind: String = "com.clouddroid.DaysCounter.SingleEvent"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectEventIntent.self,
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
        if let data = entry.data {
            ZStack {
                VStack {
                    HStack {
                        Spacer(minLength: 0)
                        CounterStacks(data: data)
                    }
                    Spacer()
                    HStack {
                        VStack(
                            alignment: .leading,
                            spacing: 5
                        ) {
                            Text(data.name)
                                .font(
                                    .custom(
                                        data.fontType,
                                        size: family == .systemMedium ? 20 : 17,
                                        relativeTo: family == .systemMedium ? .title3 : .body
                                    )
                                )
                                .fontWeight(.bold)
                            Text(data.eventDate.formatted(date: .abbreviated, time: .omitted))
                                .font(
                                    .custom(
                                        data.fontType,
                                        size: family == .systemMedium ? 13 : 12,
                                        relativeTo: family == .systemMedium ? .footnote : .caption
                                    )
                                )
                                .lineLimit(1)
                        }
                        .foregroundStyle(Color(uiColor: data.fontColor))
                        
                        Spacer(minLength: 0)
                    }
                }
                .padding(margins)
                .background {
                    Image(uiImage: data.image)
                        .resizable()
                        .scaledToFill()
                        .overlay {
                            Color(UIColor.black)
                                .opacity(data.imageDim)
                        }
                }
                .widgetURL(URL(string: "dayscounter://event/\(data.id)"))
            }
        } else {
            Text("Edit the widget to select an event.")
                .multilineTextAlignment(.center)
                .padding(margins)
        }
    }
}

private struct CounterStacks: View {
    let data: SingleEventData
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        HStack {
            if data.eventDate.representsTheSameDayAs(otherDate: Date()) {
                Text("Today")
                    .font(
                        .custom(
                            data.fontType,
                            size: family == .systemMedium ? 28 : 22,
                            relativeTo: family == .systemMedium ? .title : .title2
                        )
                    )
                    .foregroundStyle(Color(uiColor: data.fontColor))
                    .fontWeight(.heavy)
            } else {
                if let years = data.dateComponents.years {
                    CounterStack(number: years, label: "years", data: data)
                }
                if let months = data.dateComponents.months {
                    CounterStack(number: months, label: "months", data: data)
                }
                if let weeks = data.dateComponents.weeks {
                    CounterStack(number: weeks, label: "weeks", data: data)
                }
                if let days = data.dateComponents.days {
                    CounterStack(number: days, label: "days", data: data)
                }
            }
        }
    }
}

private struct CounterStack: View {
    let number: Int
    let label: String
    
    let data: SingleEventData
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack {
            Text(String(number))
                .font(
                    .custom(
                        data.fontType,
                        size: family == .systemMedium ? 28 : 22,
                        relativeTo: family == .systemMedium ? .title : .title2
                    )
                )
                .fontWeight(.heavy)
            Text(label)
                .font(
                    .custom(
                        data.fontType,
                        size: family == .systemMedium ? 15 : 13,
                        relativeTo: family == .systemMedium ? .subheadline : .footnote
                    )
                )
        }
        .foregroundStyle(Color(uiColor: data.fontColor))
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
