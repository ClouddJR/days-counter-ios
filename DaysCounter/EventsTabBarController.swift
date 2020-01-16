//
//  EventsTabBarController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 24/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class EventsTabBarController: UITabBarController {
    
    private var userDefaultsObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerUserDefaultsObserver()
    }
    
    private func registerUserDefaultsObserver() {
        userDefaultsObserver = UserDefaults.standard.observe(\.user_defaults_default_section, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            
            let sectionOrder = Defaults.getDefaultSection()
            switch sectionOrder {
            case .Future:
                self?.viewControllers?.sort(by: { (viewController1, viewController2) -> Bool in
                    return String(describing: viewController1) < String(describing: viewController2)
                })
            case .Past:
                self?.viewControllers?.sort(by: { (viewController1, viewController2) -> Bool in
                    return String(describing: viewController1) > String(describing: viewController2)
                })
            }
            self?.selectedIndex = 0
        })
    }
    
    deinit {
        userDefaultsObserver?.invalidate()
        userDefaultsObserver = nil
    }
}
