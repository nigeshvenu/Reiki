//
//  UserModal.swift
//  iAautoauction
//
//  Created by NewAgeSMB on 19/01/21.
//  Copyright © 2021 NewAgeSMB. All rights reserved.
//

import UIKit


struct Configuration{
    var point = ""
    var type = ""
}

class UserModal: NSObject {

    static var sharedInstance = UserModal()
    var userId = ""
    var firstName = ""
    var lastName = ""
    var address = ""
    var email = ""
    var phoneCode = ""
    var phone = ""
    var image = ""
    var aboutMe = ""
    var city = ""
    var state = ""
    var zip = ""
    var avatar = "Micheal"
    var configuration = [Configuration]()
    var coin = ""
    var lastCardFinder : Date?
    var cardFinderInterval = ""
    var userThemes = [ThemeModal]()
    var levelNumber = ""
    var points = ""
    var prestige = false
    var timeZone : TimeZoneModal?
    var send_custom_push = true
    var send_public_push = true
    var totalPrestigeRestart = ""
    
    func createModal(dict:[String:Any]){
        self.userId = anyToStringConverter(dict: dict, key: "id")
        self.firstName = anyToStringConverter(dict: dict, key: "first_name")
        self.lastName = anyToStringConverter(dict: dict, key: "last_name")
        self.email = anyToStringConverter(dict: dict, key: "email")
        self.phoneCode = anyToStringConverter(dict: dict, key: "phone_code")
        self.phone = anyToStringConverter(dict: dict, key: "phone")
        self.image = anyToStringConverter(dict: dict, key: "image_url")
        self.aboutMe = anyToStringConverter(dict: dict, key: "about_me")
        self.city = anyToStringConverter(dict: dict, key: "city")
        self.state = anyToStringConverter(dict: dict, key: "state")
        self.zip = anyToStringConverter(dict: dict, key: "zip")
        self.avatar = anyToStringConverter(dict: dict, key: "avatar")
        self.coin = anyToStringConverter(dict: dict, key: "coin")
        let cardFinderDate = anyToStringConverter(dict: dict, key: "last_card_finder_at")
        if !cardFinderDate.isEmpty{
            let dateString = cardFinderDate.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            if let date = dateString.date(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"){
                lastCardFinder = date
            }
        }else{
            lastCardFinder = nil
        }
        if let level = dict["level"] as? [String:Any]{
            self.levelNumber = anyToStringConverter(dict: level, key: "level_number")
        }
        self.points = anyToStringConverter(dict: dict, key: "point")
        self.prestige = anyToBoolConverter(dict: dict, key: "prestige")
        if let timezone = dict["timezone"] as? [String:Any]{
           let modal = TimeZoneModal()
            modal.createModal(dict: timezone)
            self.timeZone = modal
        }
        self.send_custom_push = anyToBoolConverter(dict: dict, key: "send_custom_push")
        self.send_public_push = anyToBoolConverter(dict: dict, key: "send_public_push")
        //self.prestige = true
        //self.levelNumber = "12"
        self.totalPrestigeRestart = anyToStringConverter(dict: dict, key: "total_restart")
    }
    
    func reset(){
        UserModal.sharedInstance = UserModal()
    }
}
