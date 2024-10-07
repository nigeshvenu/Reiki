//
//  CardModal.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/10/22.
//

import UIKit

class CardModal: NSObject {
    var cardId = ""
    var goldCoins = ""
    var name = ""
    var occurance = ""
    var random = "1"
    
    func createModal(dict:[String:Any]){
        self.cardId = anyToStringConverter(dict: dict, key: "id")
        self.goldCoins = anyToStringConverter(dict: dict, key: "gold_coins")
        self.name = anyToStringConverter(dict: dict, key: "name")
        self.occurance = anyToStringConverter(dict: dict, key: "occurrence")
        self.random = anyToStringConverter(dict: dict, key: "random")
    }
}
