//
//  SettingsSection.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 16/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import Foundation

enum SettingsSection: Int, CaseIterable {
    case General, About
    
    static func getSectionTitle(for section: SettingsSection) -> String {
        switch section {
        case .General: return NSLocalizedString("General", comment: "")
        case .About: return NSLocalizedString("About", comment: "")
        }
    }
}

protocol Section {
    func getTitle() -> String
    func getSubtitle() -> String
}

enum GeneralSection: Int, CaseIterable {
    case SortingOrder, DefaultSection, Premium, RateThisApp
    
    static func getOptionTitle(for option: GeneralSection) -> String {
        switch option {
        case .SortingOrder: return NSLocalizedString("Sorting order", comment: "")
        case .DefaultSection: return NSLocalizedString("Default section", comment: "")
        case .Premium: return NSLocalizedString("Premium", comment: "")
        case .RateThisApp: return NSLocalizedString("Rate this app", comment: "")
        }
    }
    
    static func getOptionSubtitle(for option: GeneralSection) -> String {
        switch option {
        case .SortingOrder: return Defaults.SortingOrder.getOptionTitle(for: Defaults.getSortingOrder())
        case .DefaultSection: return Defaults.DefaultSection.getOptionTitle(for: Defaults.getDefaultSection())
        case .Premium: return ""
        case .RateThisApp: return ""
        }
    }
}

enum AboutSection: Int, CaseIterable {
    case PrivacyPolicy, ContactMe
    
    static func getOptionTitle(for option: AboutSection) -> String {
        switch option {
        case .PrivacyPolicy: return NSLocalizedString("Privacy policy", comment: "")
        case .ContactMe: return NSLocalizedString("Contact me", comment: "")
        }
    }
    
    static func getOptionSubtitle(for option: AboutSection) -> String {
        switch option {
        case .PrivacyPolicy: return ""
        case .ContactMe: return ""
        }
    }
}
