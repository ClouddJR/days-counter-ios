import Foundation
import RealmSwift

class Event: Object, Codable {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var date: Date?
    @objc dynamic var isEntireDay = true
    @objc dynamic var notes = ""
    @objc dynamic var repetition = 0
    @objc dynamic var reminderDate: Date?
    @objc dynamic var reminderMessage = ""
    @objc dynamic var localImagePath = ""
    @objc dynamic var cloudImagePath = ""
    @objc dynamic var areYearsIncluded = false
    @objc dynamic var areMonthsIncluded = false
    @objc dynamic var areWeeksIncluded = false
    @objc dynamic var areDaysIncluded = true
    @objc dynamic var isTimeIncluded = false
    @objc dynamic var fontColor: Data?
    @objc dynamic var fontType = ""
    @objc dynamic var imageDim: Float = 0.2
    @objc dynamic var createdAt: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func isTheSame(as other: Event) -> Bool {
        return self.id == other.id &&
        self.name == other.name &&
        self.date == other.date &&
        self.isEntireDay == other.isEntireDay &&
        self.notes == other.notes &&
        self.repetition == other.repetition &&
        self.localImagePath == other.localImagePath &&
        self.cloudImagePath == other.cloudImagePath &&
        self.areYearsIncluded == other.areYearsIncluded &&
        self.areMonthsIncluded == other.areMonthsIncluded &&
        self.areWeeksIncluded == other.areWeeksIncluded &&
        self.areDaysIncluded == other.areDaysIncluded &&
        self.isTimeIncluded == other.isTimeIncluded &&
        self.fontColor == other.fontColor &&
        self.fontType == other.fontType &&
        self.imageDim == other.imageDim &&
        self.createdAt == other.createdAt
    }
    
    func copyValues(from other: Event) {
        self.name = other.name
        self.date = other.date
        self.isEntireDay = other.isEntireDay
        self.notes = other.notes
        self.repetition = other.repetition
        self.localImagePath = other.localImagePath
        self.cloudImagePath = other.cloudImagePath
        self.areYearsIncluded = other.areYearsIncluded
        self.areMonthsIncluded = other.areMonthsIncluded
        self.areWeeksIncluded = other.areWeeksIncluded
        self.areDaysIncluded = other.areDaysIncluded
        self.isTimeIncluded = other.isTimeIncluded
        self.fontColor = other.fontColor
        self.fontType = other.fontType
        self.imageDim = other.imageDim
        self.createdAt = other.createdAt
    }
}

final class EventOperator {
    static let IMAGE_FILE_PREFIX = "pre-installed:"
    private static let IMAGE_FILE_LENGTH = 30
    
    static func getNextId() -> String {
        return NSUUID().uuidString
    }
    
    static func doesEventContainsPreInstalledImage(_ event: Event) -> Bool {
        return event.localImagePath.contains(IMAGE_FILE_PREFIX)
    }
    
    static func updateFontColor(with color: UIColor, for event: Event) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        event.fontColor = data
    }
    
    static func getFontColor(from event: Event) -> UIColor {
        if let fontColor = event.fontColor {
            if let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: fontColor) {
                return color
            }
        }
        return UIColor.white
    }
    
    static func getImage(from event: Event) -> UIImage {
        var image: UIImage?
        if event.localImagePath.contains(IMAGE_FILE_PREFIX) {
            let imageNameBeginIndex = event.localImagePath.index(after: event.localImagePath.firstIndex(of: ":")!)
            let imageName = event.localImagePath[imageNameBeginIndex...]
            image = UIImage(named: String(imageName))
        } else {
            image = UIImage(contentsOfFile: event.localImageFilePath)
        }
        
        return image ?? UIImage(named: "nature4.jpg")!
    }
    
    static func getDate(from event: Event) -> Date {
        var date: Date?
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: event.date!)
        if !event.isEntireDay {
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: event.date!)
            date = Calendar.current.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute))
        } else {
            date = Calendar.current.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day))
        }
        
        return date!
    }
    
    static func setImageAndSaveLocally(image: UIImage, for event: Event, _ isInEditMode: Bool) {
        let imageInfo = String(describing: image)
        
        if isImageFromPreInstalledGallery(imageInfo) {
            let localImageName = imageInfo.slice(from: "named(main: ", to: ")")!
            event.localImagePath = "\(IMAGE_FILE_PREFIX)\(localImageName)"
        } else {
            if isInEditMode && image.pngData() == UIImage(contentsOfFile: event.localImageFilePath)?.pngData() {
                return
            }
            if let filePath = getFilePathWithAppendedFileName() {
                saveImageLocally(image: image, on: filePath)
                event.localImagePath = filePath.pathForEventImage()
            }
        }
    }
    
    static func getFilePathWithAppendedFileName() -> URL? {
        let path = AppGroup.imagesDirectoryUrl
        
        if !FileManager.default.fileExists(atPath: path.path) {
            do {
                try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true)
            } catch {
                print("Error creating a directory for storing images: \(error)")
            }
        }
        
        return path.appending(path: "\(String.random(length: IMAGE_FILE_LENGTH)).png")
    }
    
    private static func isImageFromPreInstalledGallery(_ imageInfo: String) -> Bool {
        return imageInfo.contains("named(main:")
    }
    
    private static func saveImageLocally(image: UIImage, on path: URL) {
        do {
            try image.pngData()?.write(to: path, options: .atomic)
        } catch {
            print("Error saving the image \(error)")
        }
    }
}
