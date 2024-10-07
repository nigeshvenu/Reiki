//
//  BadgeModal.swift
//  Reiki
//
//  Created by NewAgeSMB on 22/11/22.
//

import UIKit

class BadgeModal: NSObject {
    var badge = ""
    var badgeDate = ""
    var badgeDesc = ""

    func createModal(dict:[String:Any]){
        if let badge = dict["badge"] as? [String:Any]{
            self.badge = anyToStringConverter(dict: badge, key: "name")
            let date = anyToStringConverter(dict: dict, key: "created_at")
            badgeDate = date.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "MM/dd/yyyy")
            self.badgeDesc = anyToStringConverter(dict: badge, key: "description")
        }
    }
    
    func createBadgeModal(dict:[String:Any]){
        self.badge = anyToStringConverter(dict: dict, key: "name")
        self.badgeDesc = anyToStringConverter(dict: dict, key: "description")
        let date = anyToStringConverter(dict: dict, key: "created_at")
        badgeDate = date.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "MM/dd/yyyy")
        
    }
}
