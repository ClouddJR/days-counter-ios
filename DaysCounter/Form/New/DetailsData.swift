import Foundation

struct DetailsData {
    var name = ""
    var date = Date()
    var isEntireDay = true
    var repetition: EventRepetition = .once
    var notes = ""
    var hasReminder = false
    var reminderDate = Date()
    var reminderMessage = ""
}
