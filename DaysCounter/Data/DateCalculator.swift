import Foundation

final class DateCalculator {
    static func calculateDate(eventDate: Date, todayDate: Date = Date(),
                              areYearsIncluded: Bool,
                              areMonthsIncluded: Bool,
                              areWeekIncluded: Bool,
                              areDaysIncluded: Bool,
                              isTimeIncluded: Bool) -> CalculatedComponents {
        var todayDateCopy = todayDate
        var eventDateCopy = eventDate
        
        var yearsNumber: Int?
        var monthsNumber: Int?
        var weeksNumber: Int?
        var daysNumber: Int?
        
        var hoursNumber: Int?
        var minutesNumber: Int?
        var secondsNumber: Int?
        
        if eventDate > todayDate {
            let tempDate = todayDateCopy
            todayDateCopy = eventDateCopy
            eventDateCopy = tempDate
        }
        
        // Calculate years
        if areYearsIncluded {
            yearsNumber = 0
            while eventDateCopy < todayDateCopy {
                eventDateCopy = eventDateCopy.add(years: 1)!
                yearsNumber! += 1
            }
            if !eventDateCopy.representsTheSameDayAs(otherDate: todayDateCopy) {
                eventDateCopy = eventDateCopy.subtract(years: 1)!
                yearsNumber! -= 1
            }
        }
        
        // Calculate months
        if areMonthsIncluded {
            monthsNumber = 0
            while eventDateCopy < todayDateCopy {
                eventDateCopy = eventDateCopy.add(months: 1)!
                monthsNumber! += 1
            }
            if !eventDateCopy.representsTheSameDayAs(otherDate: todayDateCopy) {
                eventDateCopy = eventDateCopy.subtract(months: 1)!
                monthsNumber! -= 1
            }
        }
        
        // Calculate weeks
        if areWeekIncluded {
            weeksNumber = 0
            while eventDateCopy < todayDateCopy {
                eventDateCopy = eventDateCopy.add(days: 7)!
                weeksNumber! += 1
            }
            if !eventDateCopy.representsTheSameDayAs(otherDate: todayDateCopy) {
                eventDateCopy = eventDateCopy.subtract(days: 7)!
                weeksNumber! -= 1
            }
        }
        
        // Calculate days
        if areDaysIncluded {
            daysNumber = 0
            while eventDateCopy < todayDateCopy {
                eventDateCopy = eventDateCopy.add(days: 1)!
                daysNumber! += 1
            }
            if !eventDateCopy.representsTheSameDayAs(otherDate: todayDateCopy) {
                eventDateCopy = eventDateCopy.subtract(days: 1)!
                daysNumber! -= 1
            }
        }
        
        // Calculate hours, minutes and seconds
        if isTimeIncluded {
            hoursNumber = 0
            minutesNumber = 0
            secondsNumber = 0
            
            if eventDateCopy > todayDateCopy {
                eventDateCopy = eventDateCopy.subtract(days: 1)!
                let components = calculateDate(eventDate: eventDateCopy, areYearsIncluded: areYearsIncluded, areMonthsIncluded: areMonthsIncluded, areWeekIncluded: areWeekIncluded, areDaysIncluded: areDaysIncluded, isTimeIncluded: false)
                yearsNumber = components.years
                monthsNumber = components.months
                weeksNumber = components.weeks
                daysNumber = components.days
            }
            
            // Hours
            while eventDateCopy < todayDateCopy {
                eventDateCopy = eventDateCopy.add(hours: 1)!
                hoursNumber! += 1
            }
            if !eventDateCopy.representsTheSameTimeAs(otherDate: todayDateCopy) {
                eventDateCopy = eventDateCopy.subtract(hours: 1)!
                hoursNumber! -= 1
            }
            
            // Minutes
            while eventDateCopy < todayDateCopy {
                eventDateCopy = eventDateCopy.add(minutes: 1)!
                minutesNumber! += 1
            }
            if !eventDateCopy.representsTheSameTimeAs(otherDate: todayDateCopy) {
                eventDateCopy = eventDateCopy.subtract(minutes: 1)!
                minutesNumber! -= 1
            }
            
            // Seconds
            while eventDateCopy < todayDateCopy {
                eventDateCopy = eventDateCopy.add(seconds: 1)!
                secondsNumber! += 1
            }
            if !eventDateCopy.representsTheSameTimeAs(otherDate: todayDateCopy) {
                eventDateCopy = eventDateCopy.subtract(seconds: 1)!
                secondsNumber! -= 1
            }
        }
        
        return CalculatedComponents(years: yearsNumber, months: monthsNumber, weeks: weeksNumber, days: daysNumber, hours: hoursNumber, minutes: minutesNumber, seconds: secondsNumber)
    }
}

struct CalculatedComponents {
    var years: Int?
    var months: Int?
    var weeks: Int?
    var days: Int?
    
    var hours: Int?
    var minutes: Int?
    var seconds: Int?
}
