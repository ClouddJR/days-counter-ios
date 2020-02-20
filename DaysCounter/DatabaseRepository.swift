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
    
    let localDatabase: LocalDatabase
    let remoteDatabase: RemoteDatabase
    let userRepository: UserRepository
    
    init(userRepository: UserRepository = UserRepository(),
         localDatabase: LocalDatabase = LocalDatabase(),
         remoteDatabase: RemoteDatabase = RemoteDatabase()) {
        self.localDatabase = localDatabase
        self.remoteDatabase = remoteDatabase
        self.userRepository = userRepository
    }
    
    func addOrUpdateEvent(_ event: Event) {
        localDatabase.addOrUpdateEvent(event)
        if userRepository.isUserLoggedIn() {
            remoteDatabase.addOrUpdateEvent(event)
        }
    }
    
    func getEvent(with id: String) -> Event {
        return localDatabase.getEvent(with: id)
    }
    
    func deleteEvent(event: Event) {
        let eventId = event.id!
        localDatabase.deleteEvent(event)
        if userRepository.isUserLoggedIn() {
            remoteDatabase.deleteEvent(with: eventId)
        }
    }
    
    func getFutureEvents() -> Results<Event> {
        return localDatabase.getFutureEvents()
    }
    
    func getPastEvents() -> Results<Event> {
        return localDatabase.getPastEvents()
    }
    
    func repeatEventsIfNecessary() {
        let realm = try! Realm()
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())! as NSDate
        let pastEvents = localDatabase.getPastEvents(date)
        for event in pastEvents {
            if !event.date!.representsTheSameDayAs(otherDate: Date()) {
                let eventRepetition = EventRepetition(rawValue: event.repetition)!
                try! realm.write {
                    switch eventRepetition {
                    case .once: return
                    case .daily: do {
                        event.date = event.date?.add(days: 1)
                        if userRepository.isUserLoggedIn() {remoteDatabase.addOrUpdateEvent(event)}
                        }
                    case .weekly: do {
                        event.date = event.date?.add(days: 7)
                        if userRepository.isUserLoggedIn() {remoteDatabase.addOrUpdateEvent(event)}
                        }
                    case .monthly: do {
                        event.date = event.date?.add(months: 1)
                        if userRepository.isUserLoggedIn() {remoteDatabase.addOrUpdateEvent(event)}
                        }
                    case .yearly: do {
                        event.date = event.date?.add(years: 1)
                        if userRepository.isUserLoggedIn() {remoteDatabase.addOrUpdateEvent(event)}
                        }
                    }
                }
            }
        }
    }
    
    func addLocalEventsToCloud() {
        let events = localDatabase.getAllEvents()
        remoteDatabase.addEvents(Array(events)) {
            self.fetchEventsFromTheCloud()
        }
    }
    
    func fetchEventsFromTheCloud() {
        if userRepository.isUserLoggedIn() {
            remoteDatabase.getEvents() { cloudEvents in
                DispatchQueue(label: "background").async {
                    autoreleasepool {
                        cloudEvents.forEach { cloudEvent in
                            self.localDatabase.updateLocalEvent(basedOn: cloudEvent)
                        }
                    }
                }
            }
        }
    }
}
