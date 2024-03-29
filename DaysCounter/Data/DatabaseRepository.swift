import Foundation
import RealmSwift

final class DatabaseRepository {
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
    
    func addEvent(_ event: Event) {
        localDatabase.setId(for: event)
        setUpCloudImagePath(for: event)
        localDatabase.addOrUpdateEvent(event)
        if userRepository.isUserLoggedIn() {
            if !event.cloudImagePath.isEmpty {
                remoteDatabase.addImage(for: event)
            }
            remoteDatabase.addOrUpdateEvent(event)
        }
    }
    
    func editEvent(_ event: Event) {
        let oldEvent = localDatabase.getEvent(with: event.id!)
        
        if userRepository.isUserLoggedIn() {
            
            // Previously from pre-installed, now from the storage
            if EventOperator.doesEventContainsPreInstalledImage(oldEvent) && !EventOperator.doesEventContainsPreInstalledImage(event) {
                setUpCloudImagePath(for: event)
                remoteDatabase.addImage(for: event)
            }
            
            // Previously from the storage, now from pre-installed
            if !EventOperator.doesEventContainsPreInstalledImage(oldEvent) && EventOperator.doesEventContainsPreInstalledImage(event) {
                deleteLocalImage(at: oldEvent.localImageFilePath)
                remoteDatabase.deleteImage(for: oldEvent)
            }
            
            // Previously from the storage, now different one from the storage
            if !EventOperator.doesEventContainsPreInstalledImage(oldEvent) && !EventOperator.doesEventContainsPreInstalledImage(event) && oldEvent.localImagePath != event.localImagePath {
                deleteLocalImage(at: oldEvent.localImageFilePath)
                remoteDatabase.deleteImage(for: oldEvent)
                setUpCloudImagePath(for: event)
                remoteDatabase.addImage(for: event)
            }
            
            remoteDatabase.addOrUpdateEvent(event)
        }
        
        localDatabase.addOrUpdateEvent(event)
    }
    
    private func setUpCloudImagePath(for event: Event) {
        if userRepository.isUserLoggedIn() && !EventOperator.doesEventContainsPreInstalledImage(event) {
            let imageName = URL(fileURLWithPath: event.localImagePath).lastPathComponent
            let path = "\(userRepository.getUserId())/\(event.id!)/\(imageName)"
            event.cloudImagePath = path
        }
    }
    
    func getEvent(with id: String) -> Event {
        return localDatabase.getEvent(with: id)
    }
    
    func deleteEvent(event: Event) {
        let eventId = event.id!
        deleteLocalImage(at: event.localImageFilePath)
        if userRepository.isUserLoggedIn() {
            // Remove associated image stored in the cloud
            if !event.cloudImagePath.isEmpty {
                remoteDatabase.deleteImage(for: event)
            }
            remoteDatabase.deleteEvent(with: eventId)
        }
        localDatabase.deleteEvent(event)
    }
    
    private func deleteLocalImage(at path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            print("Could not delete file: \(error)")
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
        let realm = try! Realm()
        let events = localDatabase.getAllEvents()
        
        // Write local images to the cloud
        events.forEach { event in
            try! realm.write {
                remoteDatabase.addImage(for: event)
            }
        }
        
        // Add local events and fetch those from the cloud
        remoteDatabase.addEvents(Array(events)) {
            self.fetchEventsFromTheCloud()
        }
    }
    
    func fetchEventsFromTheCloud() {
        if userRepository.isUserLoggedIn() {
            remoteDatabase.getEvents() { cloudEvents in
                DispatchQueue(label: "background").async {
                    autoreleasepool {
                        let localEvents = self.localDatabase.getAllEvents()
                        
                        var anyEventWasUpserted = false
                        var anyEventWasDeleted = false
                        
                        // Update or add events from the cloud
                        cloudEvents.forEach { cloudEvent in
                            let upserted = self.localDatabase.updateLocalEvent(basedOn: cloudEvent)
                            if upserted {
                                anyEventWasUpserted = true
                            }
                        }
                        
                        localEvents.forEach { localEvent in
                            var deleted = false
                            // Locally delete those events that were removed from the cloud
                            if cloudEvents.first(where: { (cloudEvent) -> Bool in
                                cloudEvent.id == localEvent.id
                            }) == nil {
                                self.localDatabase.deleteEvent(localEvent)
                                deleted = true
                            }
                            
                            if deleted {
                                anyEventWasDeleted = true
                            }
                            
                            // Save cloud images locally
                            if !deleted && self.shouldDownloadImage(for: localEvent) {
                                let localEventCopy = Event(value: self.localDatabase.getEvent(with: localEvent.id!))
                                self.remoteDatabase.getImage(for: localEvent) { filePath in
                                    self.localDatabase.updateLocalImagePath(forEvent: localEventCopy, withPath: filePath.pathForEventImage())
                                    localEventCopy.localImagePath = filePath.pathForEventImage()
                                    self.remoteDatabase.addOrUpdateEvent(localEventCopy)
                                    Event.refreshWidgets()
                                }
                            }
                        }
                        
                        if anyEventWasUpserted || anyEventWasDeleted {
                            Event.refreshWidgets()
                        }
                    }
                }
            }
        }
    }
    
    private func shouldDownloadImage(for event: Event) -> Bool {
        !EventOperator.doesEventContainsPreInstalledImage(event) &&
        !FileManager.default.fileExists(atPath: event.localImageFilePath) &&
        !event.cloudImagePath.isEmpty
    }
}
