//
//  UserDefaultsHelper.swift
//  Showcase
//
//  Created by NewAgeSMB on 10/08/21.
//

import UIKit

class UserDefaultsHelper: NSObject {

    func saveAvatarDate(date:Date,index:Int){
        let defaults = UserDefaults.standard
        defaults.set(date, forKey: "avatarDate")
        defaults.set(index, forKey: "avatarIndex")
    }
    
    func getAvatarIndex(withInterval:CGFloat)->(Int,CGFloat){
        var avatarDate : Date?
        var avatarIndex : Int?
        let defaults = UserDefaults.standard
        avatarDate = (defaults .object(forKey: "avatarDate")) as? Date
        avatarIndex = (defaults .object(forKey: "avatarIndex")) as? Int
        if avatarDate == nil{
           saveAvatarDate(date: Date(), index: 1)
           return (1,withInterval)
        }else{
            //let dateDifference = Date().minutes(from: avatarDate!)
            let dateDifference = Date().seconds(from: avatarDate!)
            if CGFloat(dateDifference) >= withInterval{
                let maxIndex = UserModal.sharedInstance.avatar == "Micheal" ? 3 : 8
                let index = avatarIndex! == maxIndex ? 1 : avatarIndex! + 1
                saveAvatarDate(date: Date(), index: index)
                return (index,withInterval)
            }else{
                let remainingTime = withInterval - CGFloat(dateDifference)
                return (avatarIndex!,remainingTime)
            }
        }
    }
    
    func clearAvatarDate(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "avatarDate")
        defaults.removeObject(forKey: "avatarIndex")
    }
    
    func saveUser(firstname: String, lastname:String, image:String){
        let defaults = UserDefaults.standard
        defaults.set(firstname, forKey: "firstname")
        defaults.set(lastname, forKey: "lastname")
        defaults.set(image, forKey: "image")
        print("User Saved")
    }
    
    func getUser()->(String,String,String){
        let defaults = UserDefaults.standard
        var firsName = ""
        var lastName = ""
        var image = ""
        if ((defaults .object(forKey: "firstname") as? String) != nil) {
            firsName = (defaults .object(forKey: "firstname") as? String)!
        }
        if ((defaults .object(forKey: "lastname") as? String) != nil) {
            lastName = (defaults .object(forKey: "lastname") as? String)!
        }
        if ((defaults .object(forKey: "image") as? String) != nil) {
            image = (defaults .object(forKey: "image") as? String)!
        }
        return (firsName,lastName,image)
    }
    
    func saveToken(token: String){
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "token")
        print("token Saved : \(token)")
    }
    
    func saveRefreshToken(token: String){
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "refresh_token")
        print("Refresh Token Saved : \(token)")
    }
    
    func saveTokenExpiryDate(date: String){
        let defaults = UserDefaults.standard
        defaults.set(date, forKey: "token_expiry")
        print("Token Expiry Saved : \(date)")
    }
    
    func saveSessionId(id: String){
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: "session_id")
        print("Session ID Saved : \(id)")
    }
    
    func getToken()->String{
        let defaults = UserDefaults.standard
        var headerval = ""
        if ((defaults .object(forKey: "token") as? String) != nil) {
            headerval = (defaults .object(forKey: "token") as? String)!
        }
        return headerval
    }
    
    func getSessionId()->String{
        let defaults = UserDefaults.standard
        var headerval = ""
        if ((defaults .object(forKey: "session_id") as? String) != nil) {
            headerval = (defaults .object(forKey: "session_id") as? String)!
        }
        return headerval
    }
    
    func getRefreshToken()->String{
        let defaults = UserDefaults.standard
        var headerval = ""
        if ((defaults .object(forKey: "refresh_token") as? String) != nil) {
            headerval = (defaults .object(forKey: "refresh_token") as? String)!
        }
        return headerval
    }
    
    func getTokenExpiry()->String{
        let defaults = UserDefaults.standard
        var headerval = ""
        if ((defaults .object(forKey: "token_expiry") as? String) != nil) {
            headerval = (defaults .object(forKey: "token_expiry") as? String)!
        }
        return headerval
    }
    
    func clearUserdefaults(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "firstname")
        defaults.removeObject(forKey: "lastname")
        defaults.removeObject(forKey: "image")
        defaults.removeObject(forKey: "token")
        defaults.removeObject(forKey: "refresh_token")
        defaults.removeObject(forKey: "token_expiry")
        defaults.removeObject(forKey: "session_id")
        defaults.removeObject(forKey: "customGear")
        self.clearAvatarDate()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
