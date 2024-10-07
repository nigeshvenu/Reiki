//
//  DateHelper.swift
//  acuPICK Patient
//
//  Created by NewAgeSMB/ArunK on 10/16/17.
//  Copyright © 2017 NewAgeSMB Inc. All rights reserved.
//

import Foundation

extension Date {

    func offsetFrom(date: Date) -> String {

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)

        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours

        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }

}
extension Date {
 
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func monthAsString() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMMM")
            return df.string(from: self)
    }
    
    func toString( dateFormat format  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toStringCurrent( dateFormat format  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale.init(identifier:"en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    func toStringUTC( dateFormat format  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns hours
    func hoursString() -> Int {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        let hour = components.hour!
        return hour
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    // Returns date components of a date
    func getDateComponets(from date: Date) -> DateComponents {
        let cal = Calendar(identifier: .gregorian)
        let components = cal.dateComponents([.year, .month, .day], from: date)
        return components
    }
    // Returns number of days in a month
    func getNumberOfDaysInMonth(from date: Date) -> Int {
        let components = date.getDateComponets(from: date)
        let dateComponents = DateComponents(year: components.year, month: components.month)
        let calendar = Calendar.current
        let newDate = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: newDate)!
        return range.count
    }
    // Convert Local to UTC
    func localToUTC(date:String, withFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = withFormat
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    // Convert UTC to Local
    func UTCToLocal(date:String, withFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = withFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    // Convert from datetime to string
    func convertDateToString(date: Date, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = toFormat
        // converting to string from date
        return dateFormatter.string(from: date)
    }
    
    // Convert from string to datetime
    func convertStringToDate(date: String, fromFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = fromFormat
        // converting to date from string
        return dateFormatter.date(from: date)!
    }
    
    func convertDateStringToDateString(dateString:String,fromFormat:String,toFormat:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = fromFormat
        // converting to date from string
        let convertDate = dateFormatter.date(from: dateString)!
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter1.dateFormat = toFormat
        // converting to string from date
        return dateFormatter1.string(from: convertDate)
        
    }
    // Convert UTC (or GMT) to local time
       func toLocalTime() -> Date {
           let timezone = TimeZone.current
           let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
           return Date(timeInterval: seconds, since: self)
       }
    
    
    /*func createDate(date:String,time:String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "\(date) \(time)")
        let stringDate = someDateTime?.convertDateToString(date: someDateTime!, toFormat: "yyyy/MM/dd HH:mm")
        return stringDate
    }*/
}

//MARK:- Start of Week
extension Date {
    var startOfCurrentWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        let tempDate = gregorian.date(byAdding: .day, value: 1, to: sunday)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: tempDate!)
        components.hour = 00
        components.minute = 00
        components.second = 00
        gregorian.timeZone = TimeZone(secondsFromGMT: 0)!
        return gregorian.date(from: components)!
    }
    
}

extension Date {
    var startOfWeekMonday: Date? {
        let gregorian = Calendar(identifier: .iso8601)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var endOfWeekSunday: Date? {
        let gregorian = Calendar(identifier: .iso8601)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }
    
    var startOfWeekSunday: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var endOfWeekSaturday: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let saturday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: saturday)
    }
}


extension String {
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func dateUTC(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func date(timeZone:String,format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension String {
       
    //MARK:- Convert UTC To Local Date by passing date formats value
    func TimeZoneToLocal(timezone:String,incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outGoingFormat
        if let dateString = dt{
           return dateFormatter.string(from: dateString)
        }
        return ""
    }
    
       //MARK:- Convert UTC To Local Date by passing date formats value
       func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = incomingFormat
           dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
           
           let dt = dateFormatter.date(from: self)
           dateFormatter.timeZone = TimeZone.current
           dateFormatter.dateFormat = outGoingFormat
           if let dateString = dt{
              return dateFormatter.string(from: dateString)
           }
           return ""
       }
       
       //MARK:- Convert Local To UTC Date by passing date formats value
       func localToUTC(incomingFormat: String, outGoingFormat: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = incomingFormat
           dateFormatter.calendar = NSCalendar.current
           dateFormatter.timeZone = TimeZone.current
           
           let dt = dateFormatter.date(from: self)
           dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
           dateFormatter.dateFormat = outGoingFormat
           
           return dateFormatter.string(from: dt ?? Date())
       }

    //MARK:- Convert Local To UTC Date by passing date formats value
    func UTCToUTC(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = outGoingFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
