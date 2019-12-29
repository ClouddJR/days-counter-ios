//
//  Event.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 08/10/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var date: Date?
    @objc dynamic var time: Date?
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
    @objc dynamic var imageDim: Float = 0.0
    @objc dynamic var createdAt: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class EventOperator {
    
    private static let IMAGE_FILE_LENGTH = 30
    private static let IMAGE_FILE_PREFIX = "pre-installed:"
    
    static func getNextId() -> String {
        return NSUUID().uuidString
    }
    
    static func updateFontColor(with color: UIColor, for event: Event) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        event.fontColor = data
    }
    
    static func getFontColor(from event: Event) -> UIColor? {
        if let fontColor = event.fontColor {
            let color =  try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: fontColor)
            return color
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
            image = UIImage(contentsOfFile: "\(NSHomeDirectory())/Documents/d9vO5ysAx6BwwtQcjsGS7D6dPE10sX.png")
        }
        
        return image ?? UIImage(named: "nature4.jpg")!
    }
    
    static func getDate(from event: Event) -> Date {
        var date: Date?
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: event.date!)
        if let eventTime = event.time {
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: eventTime)
            date = Calendar.current.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute))
        } else {
            date = Calendar.current.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day))
        }
        
        return date!
    }
    
    static func setImageAndSaveLocally(image: UIImage, for event: Event) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let imageInfo = String(describing: image)
        
        if isImageFromPreInstalledGallery(imageInfo) {
            let localImageName = imageInfo.slice(from: "named(", to: ")")!
            event.localImagePath = "\(IMAGE_FILE_PREFIX)\(localImageName)"
        } else {
            if let filePath = getFirstPathWithAppendedFileName(from: paths) {
                saveImageLocally(image: image, on: filePath)
                event.localImagePath = filePath.absoluteString
            }
        }
    }
    
    private static func isImageFromPreInstalledGallery(_ imageInfo: String) -> Bool {
        return imageInfo.contains("named")
    }
    
    private static func getFirstPathWithAppendedFileName(from paths: [URL]) -> URL? {
        if var firstPath = paths.first {
            firstPath = firstPath.appendingPathComponent("images")
            if !FileManager.default.fileExists(atPath: firstPath.path) {
                do {
                    try FileManager.default.createDirectory(atPath: firstPath.path, withIntermediateDirectories: true)
                } catch {
                    print("Error \(error)")
                }
            }
            return firstPath.appendingPathComponent("\(String.random(length: IMAGE_FILE_LENGTH)).png")
        } else {
            return nil
        }
    }
    
    private static func saveImageLocally(image: UIImage, on path: URL) {
        do {
            try image.pngData()?.write(to: path, options: .atomic)
        } catch {
            print("Error saving the image \(error)")
        }
    }
}
