import Foundation
import RealmSwift

class LocalDatabase {
    
    func setId(for event: Event) {
        event.id = event.id ?? EventOperator.getNextId()
    }
    
    func addOrUpdateEvent(_ event: Event) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(event, update: .modified)
        }
    }
    
    func updateLocalEvent(basedOn cloudEvent: Event) {
        let realm = try! Realm()
        let localEvent = realm.objects(Event.self).filter(NSPredicate(format: "id = %@", cloudEvent.id!)).first
        if let localEvent = localEvent {
            if !localEvent.isTheSame(as: cloudEvent) {
                try! realm.write {
                    localEvent.copyValues(from: cloudEvent)
                }
            }
        } else {
            try! realm.write {
                realm.add(cloudEvent, update: .modified)
            }
        }
    }
    
    func updateLocalImagePath(forEvent event: Event, withPath path: String) {
        let realm = try! Realm()
        try! realm.write {
            realm.objects(Event.self).filter(NSPredicate(format: "id = %@", event.id!)).first!.localImagePath = path
        }
    }
    
    func getEvent(with id: String) -> Event {
        let realm = try! Realm()
        return realm.objects(Event.self).filter(NSPredicate(format: "id = %@", id)).first!
    }
    
    func deleteEvent(_ event: Event) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.delete(event)
        try! realm.commitWrite()
    }
    
    func getFutureEvents() -> Results<Event> {
        let realm = try! Realm()
        return realm.objects(Event.self).filter(NSPredicate(format: "date >= %@", NSDate()))
    }
    
    func getPastEvents(_ date: NSDate = NSDate()) -> Results<Event> {
        let realm = try! Realm()
        return realm.objects(Event.self).filter(NSPredicate(format: "date < %@", date))
    }
    
    func getAllEvents() -> Results<Event> {
        let realm = try! Realm()
        return realm.objects(Event.self)
    }
}
