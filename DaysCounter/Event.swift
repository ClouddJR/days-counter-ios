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
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class EventOperator {
    
    private static let IMAGE_FILE_LENGTH = 30
    private static let IMAGE_FILE_PREFIX = "pre-installed:"
    
    static func updateFontColor(with color: UIColor, for event: Event) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        event.fontColor = data
    }
    
    static func getFontColor(from event: Event) -> UIColor? {
        if let fontColor = event.fontColor {
            let color =  try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: fontColor)
            return color
        }
        return nil
    }
    
    static func setImageAndSaveLocally(image: UIImage, for event: Event) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let imageInfo = String(describing: image)
        
        if isImageFromPreInstalledGallery(imageInfo) {
            let localImageName = imageInfo.slice(from: "named(", to: ")")!
            event.localImagePath = "\(IMAGE_FILE_PREFIX)\(localImageName)"
        } else {
            if let filePath = getFirstPathAndAppendFileName(from: paths) {
                saveImageLocally(image: image, on: filePath)
                event.localImagePath = filePath.absoluteString
            }
        }
    }
    
    private static func isImageFromPreInstalledGallery(_ imageInfo: String) -> Bool {
        return imageInfo.contains("named")
    }
    
    private static func getFirstPathAndAppendFileName(from paths: [URL]) -> URL? {
        return paths.first?.appendingPathComponent("\(String.random(length: IMAGE_FILE_LENGTH)).png")
    }
    
    private static func saveImageLocally(image: UIImage, on path: URL) {
        do {
            try image.pngData()?.write(to: path, options: .atomic)
        } catch {
            print("Error saving the image \(error)")
        }
    }
}
