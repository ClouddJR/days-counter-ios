//
//  DatabaseRepository.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 19/02/2020.
//  Copyright © 2020 CloudDroid. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseRepository {
    
    func addEvent(_ event: Event) {
        let realm = try! Realm()
        try! realm.write {
            event.id = event.id ?? EventOperator.getNextId()
            realm.add(event, update: .modified)
        }
    }
    
    func getEvent(with id: String) -> Event {
        return try! Realm().objects(Event.self).filter(NSPredicate(format: "id = %@", id)).first!
    }
    
    func deleteEvent(event: Event) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.delete(event)
        try! realm.commitWrite()
    }
    
    func getFutureEvents() -> Results<Event> {
        let realm = try! Realm()
        return realm.objects(Event.self).filter(NSPredicate(format: "date >= %@", NSDate()))
    }
    
    func getPastEvents() -> Results<Event> {
        let realm = try! Realm()
        return realm.objects(Event.self).filter(NSPredicate(format: "date < %@", NSDate()))
    }
    
    func repeatEventsIfNecessary() {
        let realm = try! Realm()
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())! as NSDate
        let pastEvents = realm.objects(Event.self).filter(NSPredicate(format: "date < %@", date))
        for event in pastEvents {
            if !event.date!.representsTheSameDayAs(otherDate: Date()) {
                let eventRepetition = EventRepetition(rawValue: event.repetition)!
                try! realm.write {
                    switch eventRepetition {
                    case .once: return
                    case .daily: event.date = event.date?.add(days: 1)
                    case .weekly: event.date = event.date?.add(days: 7)
                    case .monthly: event.date = event.date?.add(months: 1)
                    case .yearly: event.date = event.date?.add(years: 1)
                    }
                }
            }
        }
    }
}
