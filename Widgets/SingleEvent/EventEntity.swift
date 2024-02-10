import Foundation
import AppIntents

struct EventEntity: AppEntity {
    let id: String
    let name: String
    let date: Date

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Event"
    static var defaultQuery = EventQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            subtitle: date < Date() ? "Past event" : "Future event"
        )
    }
}
