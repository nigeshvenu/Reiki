//
//  HolidayModal.swift
//  Reiki
//
//  Created by Newage on 02/07/24.
//

import UIKit

class HolidayModal: NSObject {

    var title = ""
    var holidayDate = ""
    var holidayAsDate = Date()
    
    func createModal(dict:[String:Any]){
        let date = anyToStringConverter(dict: dict, key: "date")
        holidayDate = date.UTCToUTC(incomingFormat: "yyyy-MM-dd", outGoingFormat: "MM-dd-yyyy")
        holidayAsDate = holidayDate.date(format: "MM-dd-yyyy") ?? Date()
        title = anyToStringConverter(dict: dict, key: "name")
    }
        
}
