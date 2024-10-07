//
//  FavoriteModal.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/10/22.
//

import UIKit

class FavoriteModal: NSObject {
    var favoriteId = ""
    var type = ""
    var activityId = ""
    var customActivityId = ""
    var createdDate = ""
    var event = EventModal()
    
    func createModal(dict:[String:Any]){
        self.favoriteId = anyToStringConverter(dict: dict, key: "id")
        self.type = anyToStringConverter(dict: dict, key: "activity_type")
        self.activityId = anyToStringConverter(dict: dict, key: "activity_id")
        self.customActivityId = anyToStringConverter(dict: dict, key: "custom_activity_id")
        if let eventDict = dict["activity"] as? [String:Any]{
            let modal = EventModal()
            modal.createModal(dict: eventDict)
            let created = anyToStringConverter(dict: eventDict, key: "date")
            createdDate = created.UTCToUTC(incomingFormat: "yyyy-MM-dd", outGoingFormat: "MMMM d yyyy")
            print("Event : \(modal.eventTitle)")
            print("Date : \(createdDate)")
            modal.eventType = self.type == "Normal" ? .publicType : .custom
            self.event = modal
        }
        if let eventDict = dict["custom_activity"] as? [String:Any]{
            let modal = EventModal()
            modal.createModal(dict: eventDict)
            let created = anyToStringConverter(dict: eventDict, key: "date")
            createdDate = created.UTCToUTC(incomingFormat: "yyyy-MM-dd", outGoingFormat: "MMMM d yyyy")
            modal.eventType = self.type == "Normal" ? .publicType : .custom
            self.event = modal
        }
    }
}
