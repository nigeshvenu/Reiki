//
//  TimeFormatter.swift
//  Count Down
//
//  Created by Julia Grill on 14/09/2014.
//  Copyright (c) 2014 Julia Grill. All rights reserved.
//

import UIKit

struct TimeFormatter {
    
    static func secondsInDays(_ seconds: TimeInterval) -> Int {
        return secondsInHours(seconds) / 24
    }
    
    static func secondsInHours(_ seconds: TimeInterval) -> Int {
        return secondsInMinutes(seconds) / 60
    }
    
    static func secondsInMinutes(_ seconds: TimeInterval) -> Int {
        return Int(seconds) / 60
    }
    
    static func secondsInSeconds(_ seconds: TimeInterval) -> Int {
        return Int(seconds) % 60
    }
    
    static func calculateTime(now: Date,fireDate: Date) -> (String, String, String, String,String) {
       
        /*if compareDate(now: Date(), startDate: fireDate){
           return ("00", "00", "00", "00","true")
        }*/
        let countdownTime = fireDate.timeIntervalSince(now)
        let days = secondsInDays(countdownTime)
        let hours = secondsInHours(countdownTime) - secondsInDays(countdownTime) * 24
        let minutes = secondsInMinutes(countdownTime) - secondsInHours(countdownTime) * 60
        let seconds = secondsInSeconds(countdownTime)
        let daysString = days > 9 ? String(days) : "0" + String(days)
        let hoursString = hours > 9 ? String(hours) : "0" + String(hours)
        let minsString = minutes > 9 ? String(minutes) : "0" + String(minutes)
        let secString = seconds > 9 ? String(seconds) : "0" + String(seconds)
        return (daysString, hoursString,minsString, secString,"false")
    }
    
    static func compareDate(now: Date, startDate: Date) -> Bool {
        if now > startDate {
            return true
        }
        return false
    }
}
