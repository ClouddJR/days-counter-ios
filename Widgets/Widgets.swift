import WidgetKit
import SwiftUI
import RealmSwift

struct EventCounterProvider: TimelineProvider {
    private let realm: Realm
    
    init() {
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.clouddroid.dayscounter")!
        let realmPath = directory.appendingPathComponent("db.realm")
        
        var config = Realm.Configuration()
        config.fileURL = realmPath
        
        realm = try! Realm(configuration: config)
    }
    
    func placeholder(in context: Context) -> EventCounterEntry {
        // Here, also a placeholder.
        EventCounterEntry(date: Date(), emoji: "😀")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (EventCounterEntry) -> ()) {
        // If there are events in the db, show any of them.
        // If not, show a generic "Christmas" event.
        let entry = EventCounterEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Next update should be at midnight.
        var entries: [EventCounterEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = EventCounterEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct EventCounterEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct EventCounterView : View {
    var entry: EventCounterProvider.Entry
    
    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)
            
            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

struct EventCounterWidget: Widget {
    let kind: String = "com.clouddroid.DaysCounter.EventCounter"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: EventCounterProvider()
        ) { entry in
            EventCounterView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Event Counter")
        .description("Shows a counter for a single event")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    EventCounterWidget()
} timeline: {
    EventCounterEntry(date: .now, emoji: "😀")
    EventCounterEntry(date: .now, emoji: "🤩")
}
