import UIKit

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

extension UIView {
    func addBlurEffect(withStyle style: UIBlurEffect.Style) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.addSubview(blurEffectView)
        return blurEffectView
    }
}

extension URL {
    func getData() -> Data? {
        return try? Data(contentsOf: self)
    }
    
    func pathForEventImage() -> String {
        "\(AppGroup.imagesDirectory)/\(lastPathComponent)"
    }
}

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

extension UserDefaults {
    @objc dynamic var user_defaults_sorting_order: Int {
        return integer(forKey: Defaults.Key.sortingOrder.rawValue)
    }
    
    @objc dynamic var user_defaults_default_section: Int {
        return integer(forKey: Defaults.Key.defaultSection.rawValue)
    }
    
    @objc dynamic var user_defaults_event_view_type: Int {
        return integer(forKey: Defaults.Key.eventViewType.rawValue)
    }
    
    static func forAppGroup() -> UserDefaults {
        return UserDefaults(suiteName: AppGroup.identifier)!
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension UIScrollView {
    func scrollsToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: animated)
    }
}

extension Event {
    var localImageFilePath: String {
        AppGroup.containerUrl.appending(path: localImagePath).path()
    }
}
