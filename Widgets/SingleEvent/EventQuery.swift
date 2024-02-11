import Foundation
import AppIntents
import RealmSwift

struct EventQuery: EntityStringQuery {
    func entities(for identifiers: [EventEntity.ID]) async throws -> [EventEntity] {
        getRealm().objects(Event.self)
            .where {
                $0.id.in(identifiers)
            }
            .map {
                EventEntity(id: $0.id!, name: $0.name!, date: $0.date!)
            }
    }
    
    func entities(matching string: String) async throws -> [EventEntity] {
        getRealm().objects(Event.self)
            .where {
                $0.name.contains(string, options: .caseInsensitive)
            }
            .map {
                EventEntity(id: $0.id!, name: $0.name!, date: $0.date!)
            }
    }
    
    func suggestedEntities() async throws -> [EventEntity] {
        getRealm().objects(Event.self)
            .map {
                EventEntity(id: $0.id!, name: $0.name!, date: $0.date!)
            }
    }
    
    func defaultResult() async -> EventEntity? {
        getRealm().objects(Event.self)
            .map {
                EventEntity(id: $0.id!, name: $0.name!, date: $0.date!)
            }
            .first
    }
    
    private func getRealm() -> Realm {
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.clouddroid.dayscounter")!
        let realmPath = directory.appendingPathComponent("db.realm")
        
        var config = Realm.Configuration()
        config.fileURL = realmPath
        
        return try! Realm(configuration: config)
    }
}
