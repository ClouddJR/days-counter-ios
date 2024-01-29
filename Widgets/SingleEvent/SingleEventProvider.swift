import Foundation
import WidgetKit
import RealmSwift

struct SingleEventProvider: TimelineProvider {
    private let realm: Realm
    private let events: Results<Event>
    
    init() {
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.clouddroid.dayscounter")!
        let realmPath = directory.appendingPathComponent("db.realm")
        
        var config = Realm.Configuration()
        config.fileURL = realmPath
        
        realm = try! Realm(configuration: config)
        events = realm.objects(Event.self)
    }
    
    func placeholder(in context: Context) -> SingleEventEntry {
        SingleEventEntry(date: .now, data: .sample)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SingleEventEntry) -> ()) {
        completion(SingleEventEntry(date: .now, data: events.first?.map() ?? .sample))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SingleEventEntry>) -> ()) {
        let timeline = Timeline(
            entries: [
                SingleEventEntry(
                    date: .now,
                    data: events.first?.map() ?? .sample
                )
            ],
            policy: .after(nextMidnight())
        )
        completion(timeline)
    }
    
    private func nextMidnight() -> Date {
        let calendar = Calendar.current
        
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: .now) {
            let components = calendar.dateComponents([.year, .month, .day], from: nextDay)
            
            if let nextMidnight = calendar.date(from: components) {
                return nextMidnight
            }
        }
        
        // In case of any issues, return the current date.
        return .now
    }
}
