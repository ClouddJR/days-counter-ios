//
//  Extensions.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 17/09/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

// MARK:  Date extensions

extension Date {
    
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    
    func representsTheSameDayAs(otherDate date: Date) -> Bool {
        return Calendar.current.component(.day, from: self) == Calendar.current.component(.day, from: date) &&
            Calendar.current.component(.month, from: self) == Calendar.current.component(.month, from: date) &&
            Calendar.current.component(.year, from: self) == Calendar.current.component(.year, from: date)
    }
    
    func representsTheSameTimeAs(otherDate date: Date) -> Bool {
        return Calendar.current.component(.hour, from: self) == Calendar.current.component(.hour, from: date) &&
            Calendar.current.component(.minute, from: self) == Calendar.current.component(.minute, from: date) &&
            Calendar.current.component(.second, from: self) == Calendar.current.component(.second, from: date)
    }
    
    func with(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return Calendar.current.date(bySettingHour: hours, minute: minutes, second: seconds, of: self)
    }
    
    func timeComponents() -> DateComponents {
        return Calendar.current.dateComponents([.hour, .minute], from: self)
    }
    
}


// MARK:  View extensions

extension UIView {
    
    func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func addBlurEffect(withStyle style: UIBlurEffect.Style) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.addSubview(blurEffectView)
        return blurEffectView
    }
    
}

// MARK:  TableView extensions

extension UITableView {
    
    func scrollToBottom(animated: Bool) {
        var y: CGFloat = 0.0
        if self.contentSize.height > UIScreen.main.bounds.height {
            y = self.contentSize.height - UIScreen.main.bounds.height
        }
        self.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
    
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
    
}

// MARK:  URL extensions

extension URL {
    
    func getData() -> Data? {
        return try? Data(contentsOf: self)
    }
}

// MARK:  String extensions

extension String {
    
    static func random(length: Int) -> String {
      let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in chars.randomElement()! })
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

// MARK:  UserDefaults extensions

extension UserDefaults {
    @objc dynamic var user_defaults_sorting_order: Int {
        return integer(forKey: Defaults.Key.SortingOrder.rawValue)
    }
    
    @objc dynamic var user_defaults_default_section: Int {
        return integer(forKey: Defaults.Key.DefaultSection.rawValue)
    }
    
    static func forAppGroup() -> UserDefaults {
        return UserDefaults(suiteName: "group.com.clouddroid.dayscounter")!
    }
}

