//
//  ValidationHelper.swift
//  Future Gift
//
//  Created by NewAgeSMB/Nigesh on 5/11/18.
//  Copyright © 2018 NewAgeSMB. All rights reserved.
//

import Foundation

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}

func getAge(birthdate:Date)->Bool{
    
    let now = Date()
    let birthday: Date = birthdate
    let calendar = Calendar.current
    let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
    let age = ageComponents.year!
    
    if age < 18{
        
        return false
    }
    return true
}

func isValidPassword(password: String) -> Bool {
    let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
