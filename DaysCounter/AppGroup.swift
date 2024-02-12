import Foundation

struct AppGroup {
    static let identifier = "group.com.clouddroid.dayscounter"
    
    static var containerUrl: URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)!
    }
}
