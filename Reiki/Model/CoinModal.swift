//
//  CoinModal.swift
//  Reiki
//
//  Created by NewAgeSMB on 31/10/22.
//

import UIKit

class CoinModal: NSObject {
    
   var type = ""
   var date = ""
   var coin = ""
    
    func createModal(dict:[String:Any]){
        self.type = anyToStringConverter(dict: dict, key: "type")
        self.date = anyToStringConverter(dict: dict, key: "created_at")
        date = self.date.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "MM/dd/yyyy")
        self.coin = anyToStringConverter(dict: dict, key: "coin")
        let action = anyToStringConverter(dict: dict, key: "action")
        coin = "\(action)\(coin)"
    }
}
