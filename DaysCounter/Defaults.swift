//
//  UserDefaultsKey.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 19/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import Foundation

struct Defaults {
    enum Key: String {
        case SortingOrder = "user_defaults_sorting_order";
        case DefaultSection = "user_defaults_default_section";
        case Premium = "user_defaults_is_premium_user";
    }
    
    enum SortingOrder: Int, CaseIterable {
        case TimeAdded, DaysAscending, DaysDescending
        
        static func getOptionTitle(for option: SortingOrder) -> String {
            switch option {
            case .TimeAdded: return NSLocalizedString("Sort by time added", comment: "")
            case .DaysAscending: return NSLocalizedString("Sort by days ascending", comment: "")
            case .DaysDescending: return NSLocalizedString("Sort by days descending", comment: "")
            }
        }
    }
    
    enum DefaultSection: Int, CaseIterable {
        case Future, Past
        
        static func getOptionTitle(for option: DefaultSection) -> String {
            switch option {
            case .Future: return NSLocalizedString("Future", comment: "")
            case .Past: return NSLocalizedString("Past", comment: "")
            }
        }
    }
    
    static func getSortingOrder() -> SortingOrder {
        return SortingOrder(rawValue: UserDefaults.standard.integer(forKey: Defaults.Key.SortingOrder.rawValue)) ?? SortingOrder.TimeAdded
    }
    
    static func getDefaultSection() -> DefaultSection {
        return DefaultSection(rawValue: UserDefaults.standard.integer(forKey: Defaults.Key.DefaultSection.rawValue)) ?? DefaultSection.Future
    }
    
    static func setPremiumUser(_ isPremium: Bool) {
        UserDefaults.forAppGroup().set(isPremium, forKey: Defaults.Key.Premium.rawValue)
    }
    
    static func isPremiumUser() -> Bool {
        return UserDefaults.forAppGroup().bool(forKey: Defaults.Key.Premium.rawValue)
    }
}
