//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
public enum DayOfWeek: Int, Codable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    public var shortText: String {
        switch self {
        case .sunday:
            return "일"
        case .monday:
            return "월"
        case .tuesday:
            return "화"
        case .wednesday:
            return "수"
        case .thursday:
            return "목"
        case .friday:
            return "금"
        case .saturday:
            return "토"
        }
    }
    
    public var fullText: String {
        switch self {
        case .sunday:
            return "일요일"
        case .monday:
            return "월요일"
        case .tuesday:
            return "화요일"
        case .wednesday:
            return "수요일"
        case .thursday:
            return "목요일"
        case .friday:
            return "금요일"
        case .saturday:
            return "토요일"
        }
    }
}


public extension Date {
    struct Singleton {
        static let currentCalendar: Calendar = Calendar.autoupdatingCurrent
        static let currentLocale: Locale = Locale.preferredLanguages.first == nil ? Locale.current : Locale(identifier: Locale.preferredLanguages.first!)
    }
    
    static var staticCurrentCalendar: Calendar {
        return Singleton.currentCalendar
    }
    
    var yyyy: Int {
        var formatter: DateFormatter {
            struct Static {
                static var formatter: DateFormatter?
            }
            
            if Static.formatter == nil {
                Static.formatter = DateFormatter()
                Static.formatter?.locale = Singleton.currentLocale
                Static.formatter?.dateFormat = "yyyy"
            }
            return Static.formatter!
        }
        
        return Int(formatter.string(from: self)) ?? 1970
    }
    
    var yyyyMMdd: String {
        var formatter: DateFormatter {
            struct Static {
                static var formatter: DateFormatter?
            }
            
            if Static.formatter == nil {
                Static.formatter = DateFormatter()
                Static.formatter?.locale = Singleton.currentLocale
                Static.formatter?.dateFormat = "yyyyMMdd"
            }
            return Static.formatter!
        }
        
        return formatter.string(from: self)
    }
    
    var yyyyMd: String {
        var formatter: DateFormatter {
            struct Static {
                static var formatter: DateFormatter?
            }
            
            if Static.formatter == nil {
                Static.formatter = DateFormatter()
                Static.formatter?.locale = Singleton.currentLocale
                Static.formatter?.dateFormat = "yyyy-M-d"
            }
            return Static.formatter!
        }
        return formatter.string(from: self)
    }
    
    var MMMddEEEE: String {
        var formatter: DateFormatter {
            struct Static {
                static var formatter: DateFormatter?
            }
            
            if Static.formatter == nil {
                Static.formatter = DateFormatter()
                Static.formatter?.locale = Singleton.currentLocale
                Static.formatter?.dateFormat = "MMMd EEEE"
            }
            return Static.formatter!
        }
        return formatter.string(from: self)
    }
    
    var yyyyMdEahmm: String {
        var formatter: DateFormatter {
            struct Static {
                static var formatter: DateFormatter?
            }
            
            if Static.formatter == nil {
                Static.formatter = DateFormatter()
                Static.formatter?.locale = Singleton.currentLocale
                Static.formatter?.dateFormat = "yyyy. M. d. (E) a h:mm"
            }
            return Static.formatter!
        }
        
        return formatter.string(from: self)
    }
    
    var yyyyMdE: String {
        var formatter: DateFormatter {
            struct Static {
                static var formatter: DateFormatter?
            }
            
            if Static.formatter == nil {
                Static.formatter = DateFormatter()
                Static.formatter?.locale = Singleton.currentLocale
                Static.formatter?.dateFormat = "yyyy. M. d. (E)"
            }
            return Static.formatter!
        }
        
        return formatter.string(from: self)
    }
    
    var ahhmm: String {
        var formatter: DateFormatter {
            struct Static {
                static var formatter: DateFormatter?
            }
            
            if Static.formatter == nil {
                Static.formatter = DateFormatter()
                Static.formatter?.locale = Singleton.currentLocale
                Static.formatter?.dateFormat = "a hh:mm"
            }
            return Static.formatter!
        }
        return formatter.string(from: self)
    }
    
    var dateWithOutTime: Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.timeZone = TimeZone.autoupdatingCurrent
        components.hour = 00
        components.minute = 00
        components.second = 00
        return calendar.date(from: components) ?? self
    }
    
    var aDayAfter: Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.month = 0
        components.day = 1
        components.year = 0
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    var aDayBefore: Date {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: self)
        
        components.month = 0
        components.day = -1
        components.year = 0
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    // + days 이 후 자정까지
    func after(days: Int) -> Date {
        let calendar = Date.staticCurrentCalendar
        let from = calendar.startOfDay(for: self)
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: from)
        
        components.month = 0
        components.day = days
        components.year = 0
        
        return calendar.date(byAdding: components, to: from) ?? self
    }
    
    func before(days: Int) -> Date {
        let calendar = Date.staticCurrentCalendar
        let from = calendar.startOfDay(for: self)
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        var components = (calendar as NSCalendar).components(unitFlags, from: from)
        
        components.month = 0
        components.day = -days
        components.year = 0
        
        return calendar.date(byAdding: components, to: from) ?? self
    }
    
    var millisecondsSince1970: Int {
        Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    var fullDateFormatNoneTime: String {
        var formatter: DateFormatter {
            struct Static {
                static var formatter: DateFormatter?
            }
            
            if Static.formatter == nil {
                Static.formatter = DateFormatter()
                Static.formatter?.locale = Singleton.currentLocale
                Static.formatter?.doesRelativeDateFormatting = true
                Static.formatter?.timeStyle = DateFormatter.Style.none
                Static.formatter?.dateStyle = DateFormatter.Style.full
            }
            return Static.formatter!
        }
        
        return formatter.string(from: self)
    }
    
    var timeInWords: String {
        if self.isToday {
            return self.shortTime
        } else if self.isYesterday {
            return self.relativeShortDate   // localized relative date only
        } else if self.isThisYear {
            return self.monthDayDate
        }
        
        return self.relativeShortDate
    }
    
    var monthDayDate: String {
        var formatter: DateFormatter {
            struct Static {
                static var monthDayDateFormatter: DateFormatter?
            }
            
            if Static.monthDayDateFormatter == nil {
                Static.monthDayDateFormatter = DateFormatter()
                Static.monthDayDateFormatter?.locale = Singleton.currentLocale
                Static.monthDayDateFormatter?.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: Singleton.currentLocale)
                
            }
            return Static.monthDayDateFormatter!
        }
        
        return formatter.string(from: self)
    }
    
    var relativeShortDate: String {
        var formatter: DateFormatter {
            struct Static {
                static var formatter: DateFormatter?
            }
            
            if Static.formatter == nil {
                Static.formatter = DateFormatter()
                Static.formatter?.locale = Singleton.currentLocale
                Static.formatter?.doesRelativeDateFormatting = true
                Static.formatter?.timeStyle = DateFormatter.Style.none
                Static.formatter?.dateStyle = DateFormatter.Style.short
            }
            return Static.formatter!
        }
        
        return formatter.string(from: self)
    }
    
    var shortTime: String {
        var formatter: DateFormatter {
            struct Static {
                static var shortTimeFormatter: DateFormatter?
            }
            
            if Static.shortTimeFormatter == nil {
                Static.shortTimeFormatter = DateFormatter()
                Static.shortTimeFormatter?.locale = Singleton.currentLocale
                Static.shortTimeFormatter?.dateStyle = DateFormatter.Style.none
                Static.shortTimeFormatter?.timeStyle = DateFormatter.Style.short
            }
            return Static.shortTimeFormatter!
        }
        return formatter.string(from: self)
    }
    
    var minusOneDayComponents: DateComponents {
        struct Static {
            static var minusOneDayComponents: DateComponents?
        }
        
        if Static.minusOneDayComponents == nil {
            Static.minusOneDayComponents = DateComponents()
            Static.minusOneDayComponents?.day = -1
        }
        return Static.minusOneDayComponents!
    }
    
    var oneDayComponents: DateComponents {
        struct Static {
            static var oneDayComponents: DateComponents?
        }
        
        if Static.oneDayComponents == nil {
            Static.oneDayComponents = DateComponents()
            Static.oneDayComponents?.day = 1
        }
        return Static.oneDayComponents!
    }
    
    var isToday: Bool {
        return self.isSameDay(Date())
    }
    
    var isThisYear: Bool {
        return self.isSameYear(Date())
    }
    
    var isTomorrow: Bool {
        let calendar = Date.staticCurrentCalendar
        if let tomorrow = (calendar as NSCalendar).date(byAdding: oneDayComponents, to: Date(), options: NSCalendar.Options(rawValue: 0)) {
            return self.isSameDay(tomorrow)
        } else {
            return false
        }
    }
    
    var isYesterday: Bool {
        let calendar = Date.staticCurrentCalendar
        if let yesterday = (calendar as NSCalendar).date(byAdding: self.minusOneDayComponents, to: Date(), options: NSCalendar.Options(rawValue: 0)) {
            return self.isSameDay(yesterday)
        } else {
            return false
        }
    }
    
    func isSameYear(_ date: Date) -> Bool {
        let calendar = Date.staticCurrentCalendar
        let comparingYear = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: self)
        return comparingYear == currentYear
    }
    
    func isSameMonth(_ date: Date) -> Bool {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        let currentDateComponents = (calendar as NSCalendar).components(unitFlags, from: date)
        let dateComponents = (calendar as NSCalendar).components(unitFlags, from: self)
        
        if (currentDateComponents.month == dateComponents.month) && (currentDateComponents.year == dateComponents.year) {
            return true
        }
        
        return false
    }
    
    func isSameDay(_ date: Date) -> Bool {
        let calendar = Date.staticCurrentCalendar
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        let currentDateComponents = (calendar as NSCalendar).components(unitFlags, from: date)
        let dateComponents = (calendar as NSCalendar).components(unitFlags, from: self)
        
        if (currentDateComponents.day == dateComponents.day) && (currentDateComponents.month == dateComponents.month) && (currentDateComponents.year == dateComponents.year) {
            return true
        }
        
        return false
    }
    
    func toString(dateFormat format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var yyyyMMddShortTime: String {
        var formatter: DateFormatter {
            struct Static {
                static var formatter: DateFormatter?
            }
            
            if Static.formatter == nil {
                Static.formatter = DateFormatter()
                Static.formatter?.locale = Singleton.currentLocale
                Static.formatter?.dateFormat = "yyyy. M. d a hh:mm"
            }
            return Static.formatter!
        }
        return formatter.string(from: self)
    }
    
    var callaboRecordListFormat: String {
        var formatter: DateFormatter {
            struct Static {
                static var dateFormatter: DateFormatter?
            }
            
            if Static.dateFormatter == nil {
                Static.dateFormatter = DateFormatter()
                Static.dateFormatter?.locale = Singleton.currentLocale
                Static.dateFormatter?.dateFormat = "M월 d일 (E) a h:mm분"
            }
            
            return Static.dateFormatter!
        }
        
        return formatter.string(from: self)
    }
    
    func afterMinutes(_ minutes: Int) -> Date {
        let calendar = Date.staticCurrentCalendar
        var dateComponents = DateComponents()
        dateComponents.minute = minutes
        
        if let updatedDate = calendar.date(byAdding: dateComponents, to: self) {
            return updatedDate
        } else {
            return self
        }
    }
    
    func afterSeconds(_ seconds: Int) -> Date {
        let calendar = Date.staticCurrentCalendar
        var dateComponents = DateComponents()
        dateComponents.second = seconds
        
        if let updatedDate = calendar.date(byAdding: dateComponents, to: self) {
            return updatedDate
        } else {
            return self
        }
    }
    
    func getDayOfWeek() -> DayOfWeek {
        let calendar = Date.staticCurrentCalendar
        let dayOfWeek = calendar.component(.weekday, from: self)
        return DayOfWeek(rawValue: dayOfWeek) ?? .sunday
    }
}

extension Date: Identifiable {
    public var id: Self {
        self
    }
}
