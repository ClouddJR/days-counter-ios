import Foundation

struct Defaults {
    enum Key: String {
        case sortingOrder = "user_defaults_sorting_order";
        case defaultSection = "user_defaults_default_section";
        case eventViewType = "user_defaults_event_view_type";
        case premium = "user_defaults_is_premium_user";
    }
    
    enum SortingOrder: Int, CaseIterable, Identifiable {
        case timeAdded, daysAscending, daysDescending
        
        var id: Self { self }
        
        var title: String {
            switch self {
            case .timeAdded: return NSLocalizedString("By time added", comment: "")
            case .daysAscending: return NSLocalizedString("By days ascending", comment: "")
            case .daysDescending: return NSLocalizedString("By days descending", comment: "")
            }
        }
    }
    
    enum DefaultSection: Int, CaseIterable, Identifiable {
        case future, past
        
        var id: Self { self }
        
        var title: String {
            switch self {
            case .future: return NSLocalizedString("Future", comment: "")
            case .past: return NSLocalizedString("Past", comment: "")
            }
        }
    }
    
    enum EventViewType: Int, CaseIterable, Identifiable {
        case large, compact
        
        var id: Self { self }
        
        var title: String {
            switch self {
            case .large: return NSLocalizedString("Large", comment: "")
            case .compact: return NSLocalizedString("Compact", comment: "")
            }
        }
    }
    
    static func getSortingOrder() -> SortingOrder {
        SortingOrder(
            rawValue: UserDefaults.standard.integer(forKey: Defaults.Key.sortingOrder.rawValue)
        ) ?? SortingOrder.timeAdded
    }
    
    static func getDefaultSection() -> DefaultSection {
        DefaultSection(
            rawValue: UserDefaults.standard.integer(forKey: Defaults.Key.defaultSection.rawValue)
        ) ?? DefaultSection.future
    }
    
    static func getEventViewType() -> EventViewType {
        EventViewType(
            rawValue: UserDefaults.standard.integer(forKey: Defaults.Key.eventViewType.rawValue)
        ) ?? EventViewType.large
    }
    
    static func setPremiumUser(_ isPremium: Bool) {
        UserDefaults.forAppGroup().set(isPremium, forKey: Defaults.Key.premium.rawValue)
    }
    
    static func isPremiumUser() -> Bool {
        UserDefaults.forAppGroup().bool(forKey: Defaults.Key.premium.rawValue)
    }
}
