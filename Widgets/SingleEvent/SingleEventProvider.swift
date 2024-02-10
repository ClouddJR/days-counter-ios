import Foundation
import WidgetKit
import RealmSwift

struct SingleEventProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SingleEventEntry {
        SingleEventEntry(date: .now, data: .sample)
    }
    
    func snapshot(for configuration: SelectEventIntent, in context: Context) async -> SingleEventEntry {
        SingleEventEntry(date: .now, data: getEvents().first?.map() ?? .sample)
    }
    
    func timeline(for configuration: SelectEventIntent, in context: Context) async -> Timeline<SingleEventEntry> {
        Timeline(
            entries: [
                SingleEventEntry(
                    date: .now,
                    data: getRealm().object(
                        ofType: Event.self,
                        forPrimaryKey: configuration.event?.id
                    )?.map() ?? .sample // TODO: Add an enum to represent empty state
                )
            ],
            policy: .after(nextMidnight())
        )
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
    
    private func getRealm() -> Realm {
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.clouddroid.dayscounter")!
        let realmPath = directory.appendingPathComponent("db.realm")
        
        var config = Realm.Configuration()
        config.fileURL = realmPath
        
        return try! Realm(configuration: config)
    }
    
    private func getEvents() -> Results<Event> {
        getRealm().objects(Event.self)
    }
}
