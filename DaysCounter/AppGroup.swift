import Foundation

struct AppGroup {
    static let identifier = "group.com.clouddroid.dayscounter"
    static let imagesDirectory = "images"
    
    static var containerUrl: URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)!
    }
    
    static var imagesDirectoryUrl: URL {
        containerUrl.appending(path: imagesDirectory)
    }
}
