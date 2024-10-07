//
//  TimeZoneModal.swift
//  Showcase
//
//  Created by NewAgeSMB on 24/09/21.
//

import UIKit

class TimeZoneModal: NSObject {
    var id = ""
    var name = ""
    var value = ""
    
    func createModal(dict:[String:Any]){
        id = anyToStringConverter(dict: dict, key: "id")
        name = anyToStringConverter(dict: dict, key: "name")
        value = anyToStringConverter(dict: dict, key: "value")
    }
}
