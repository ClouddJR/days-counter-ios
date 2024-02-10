import Foundation
import AppIntents

struct SelectEventIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Event"
    static var description = IntentDescription("Selects the event to display a counter for.")
    
    @Parameter(title: "Event")
    var event: EventEntity?
}
