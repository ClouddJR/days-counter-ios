import Foundation
import WidgetKit
import SwiftUI

struct SingleEventEntry: TimelineEntry {
    let date: Date
    let data: SingleEventData?
}

struct SingleEventData {
    let id: String
    let name: String
    let eventDate: Date
    let dateComponents: CalculatedComponents
    let image: UIImage
    let imageDim: Double
    let fontColor: UIColor
    let fontType: String
    
    static let sample = SingleEventData(
        id: "",
        name: NSLocalizedString("Holidays", comment: ""),
        eventDate: Calendar.current.date(byAdding: .day, value: 25, to: .now)!,
        dateComponents: CalculatedComponents(days: 25),
        image: UIImage(named: "nature8.jpg")!,
        imageDim: 0.2,
        fontColor: .white,
        fontType: "Helvetica"
    )
}

extension Event {
    func map() -> SingleEventData {
        SingleEventData(
            id: id!,
            name: name!,
            eventDate: date!,
            dateComponents: DateCalculator.calculateDate(
                eventDate: EventOperator.getDate(from: self),
                areYearsIncluded: areYearsIncluded,
                areMonthsIncluded: areMonthsIncluded,
                areWeekIncluded: areWeeksIncluded,
                areDaysIncluded: areDaysIncluded,
                isTimeIncluded: isTimeIncluded
            ),
            image: EventOperator.getImage(from: self),
            imageDim: Double(imageDim),
            fontColor: EventOperator.getFontColor(from: self),
            fontType: fontType
        )
    }
}
