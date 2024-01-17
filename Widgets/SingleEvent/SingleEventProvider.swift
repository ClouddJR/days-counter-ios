import Foundation
import WidgetKit
import RealmSwift

struct SingleEventProvider: TimelineProvider {
    private let realm: Realm
    
    init() {
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.clouddroid.dayscounter")!
        let realmPath = directory.appendingPathComponent("db.realm")
        
        var config = Realm.Configuration()
        config.fileURL = realmPath
        
        realm = try! Realm(configuration: config)
    }
    
    func placeholder(in context: Context) -> SingleEventEntry {
        // Here, also a placeholder.
        SingleEventEntry(date: Date(), emoji: "😀")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SingleEventEntry) -> ()) {
        // If there are events in the db, show any of them.
        // If not, show a generic "Christmas" event.
        let entry = SingleEventEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SingleEventEntry>) -> ()) {
        // Next update should be at midnight.
        var entries: [SingleEventEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SingleEventEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
