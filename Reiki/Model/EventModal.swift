//
//  EventModal.swift
//  Reiki
//
//  Created by NewAgeSMB on 27/09/22.
//

import UIKit
enum EventType{
    case publicType
    case custom
}
class EventModal: NSObject {
  var userActivityId = ""
  var eventId = ""
  var eventDate = ""
  var eventTitle = ""
  var eventdesc = ""
  var eventImage = ""
  var journal = ""
  var eventdateAsDate = Date()
  var eventType:EventType!
  var favoriteId = ""
  var isFavorite = false
  var isCompleted = false
  var isLocked = true
    
    func createModal(dict:[String:Any]){
        eventId = anyToStringConverter(dict: dict, key: "id")
        self.eventDate = anyToStringConverter(dict: dict, key: "date")
        eventDate = self.eventDate.UTCToUTC(incomingFormat: "yyyy-MM-dd", outGoingFormat: "MM-dd-yyyy")
        self.eventTitle = anyToStringConverter(dict: dict, key: "title")
        eventdateAsDate = eventDate.date(format: "MM-dd-yyyy") ?? Date()
        self.eventImage = anyToStringConverter(dict: dict, key: "image_url")
        self.eventdesc = anyToStringConverter(dict: dict, key: "description")
        self.journal = anyToStringConverter(dict: dict, key: "journal")
        let status = anyToStringConverter(dict: dict, key: "status")
        if status == "Completed"{
           isCompleted = true
        }
    }
}
