import Foundation

struct Defaults {
    enum Key: String {
        case SortingOrder = "user_defaults_sorting_order";
        case DefaultSection = "user_defaults_default_section";
        case EventViewType = "user_defaults_event_view_type";
        case Premium = "user_defaults_is_premium_user";
    }
    
    enum SortingOrder: Int, CaseIterable, Identifiable {
        case TimeAdded, DaysAscending, DaysDescending
        var id: Self { self }
        
        var title: String {
            switch self {
            case .TimeAdded: return NSLocalizedString("By time added", comment: "")
            case .DaysAscending: return NSLocalizedString("By days ascending", comment: "")
            case .DaysDescending: return NSLocalizedString("By days descending", comment: "")
            }
        }
    }
    
    enum DefaultSection: Int, CaseIterable, Identifiable {
        case Future, Past
        var id: Self { self }
        
        var title: String {
            switch self {
            case .Future: return NSLocalizedString("Future", comment: "")
            case .Past: return NSLocalizedString("Past", comment: "")
            }
        }
    }
    
    enum EventViewType: Int, CaseIterable, Identifiable {
        case Large, Compact
        var id: Self { self }
        
        var title: String {
            switch self {
            case .Large: return NSLocalizedString("Large", comment: "")
            case .Compact: return NSLocalizedString("Compact", comment: "")
            }
        }
    }
    
    static func getSortingOrder() -> SortingOrder {
        SortingOrder(
            rawValue: UserDefaults.standard.integer(forKey: Defaults.Key.SortingOrder.rawValue)
        ) ?? SortingOrder.TimeAdded
    }
    
    static func getDefaultSection() -> DefaultSection {
        DefaultSection(
            rawValue: UserDefaults.standard.integer(forKey: Defaults.Key.DefaultSection.rawValue)
        ) ?? DefaultSection.Future
    }
    
    static func getEventViewType() -> EventViewType {
        EventViewType(
            rawValue: UserDefaults.standard.integer(forKey: Defaults.Key.EventViewType.rawValue)
        ) ?? EventViewType.Large
    }
    
    static func setPremiumUser(_ isPremium: Bool) {
        UserDefaults.forAppGroup().set(isPremium, forKey: Defaults.Key.Premium.rawValue)
    }
    
    static func isPremiumUser() -> Bool {
        UserDefaults.forAppGroup().bool(forKey: Defaults.Key.Premium.rawValue)
    }
}
