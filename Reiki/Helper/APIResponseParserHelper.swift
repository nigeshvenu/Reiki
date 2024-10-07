//
//  APIResponseParserHelper.swift
//  acuPICK Practitioner
//
//  Created by NewAgeSMB/ArunK on 9/21/17.
//  Copyright © 2017 NewAgeSMB. All rights reserved.
//

import Foundation

func anyToStringConverter(dict: [String:Any], key: String) -> String {
    if let value = dict[key]  {
        if String(describing: value) != "<null>" && String(describing: value) != "" {
            return String(describing: value)
        } else {
            return ""
        }
    } else {
        return ""
    }
}

func anyValueToStringConverter(value: Any?) -> String{
    if let val = value{
        if String(describing: val) != "<null>" && String(describing: val) != "" {
            return String(describing: val)
        } else {
            return ""
        }
    }
    return ""
}


func anyToBoolConverter(dict: [String:Any], key: String)->Bool{
    if let value = dict[key] as? Bool{
       return value
    }else if let value = dict[key] as? String{
        if value == "true" || value == "false"{
           return value == "true" ? true : false
        }else if value == "Y" || value == "N"{
            return value == "Y" ? true : false
        }else if value == "0" || value == "1"{
           return value == "1" ? true : false
        }
        return false
    }
    return false
}







