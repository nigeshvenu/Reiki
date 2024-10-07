//
//  CountryCallingCode.swift
//  iAautoauction
//
//  Created by NewAgeSMB on 18/01/21.
//  Copyright © 2021 NewAgeSMB. All rights reserved.
//

import UIKit


class CountryCallingCode: NSObject {

    class func countryNamesByCode(code:String) -> String {
        
        guard let jsonPath = Bundle.main.path(forResource: "countryCodes", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return ""
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                    for jsonObject in jsonObjects {
                        
                        guard let countryObj = jsonObject as? NSDictionary else {
                            return ""
                        }
                        guard let countryCode = countryObj["code"] as? String, let phoneCode = countryObj["dial_code"] as? String, let _ = countryObj["name"] as? String else {
                            return ""
                        }
                        if code == countryCode{
                           return phoneCode
                        }
                    }
                }
        } catch {
            return ""
        }
        return ""
    }
}

