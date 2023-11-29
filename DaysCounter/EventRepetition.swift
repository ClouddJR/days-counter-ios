import Foundation

enum EventRepetition : Int, CaseIterable, Identifiable {
    case once, daily, weekly, monthly, yearly
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .once: return NSLocalizedString("Only once", comment: "")
        case .daily: return NSLocalizedString("Daily", comment: "")
        case .weekly: return NSLocalizedString("Weekly", comment: "")
        case .monthly: return NSLocalizedString("Monthly", comment: "")
        case .yearly: return NSLocalizedString("Yearly", comment: "")
        }
    }
}
