//
//  EditProfileVM.swift
//  Showcase
//
//  Created by NewAgeSMB on 18/08/21.
//

import UIKit

class EditProfileVM: NSObject {

    var timeZoneArray = [TimeZoneModal]()
    
    func getTimeZones(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
       
        RequestManager.serverRequestWithToken(function: APIFunction.timeZone, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
            if let error = result["error"] as? String{
                if !(error.isEmpty){
                    onFailure(error)
                    return
                }
            }
            print(result)
            
            if let data = result["data"] as? [String:Any]{
                if let timeZones = data["timezones"] as? [[String:Any]]{
                    self.timeZoneArray.removeAll()
                    for timezone in timeZones{
                        let modal = TimeZoneModal()
                        modal.createModal(dict: timezone)
                        self.timeZoneArray.append(modal)
                    }
                }
            }
            
            if let message = result["message"] as? String{
               onSuccess(message)
            }

        }, onFailure: {error in
            onFailure(error)
        })
    }
    
    func updateUser(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        RequestManager.serverRequestWithToken(function: APIFunction.person, method: .put, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
               
                if let data = result["data"] as? [String:Any]{
                    if let user = data["person"] as? [String:Any]{
                        UserModal.sharedInstance.createModal(dict: user)
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    
    func updateUserProfile(param:[String:Any]?,removeImage:Bool,image:UIImage?,fileName:String,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        
        RequestManager.multipartRequest(function: APIFunction.personImage, param: param, removeImage: removeImage, image: image, fileName: fileName, onSuccess: { (result) in
            if let error = result["error"] as? String{
                if !(error.isEmpty){
                    onFailure(error)
                    return
                }
            }
            print(result)
            if let data = result["data"] as? [String:Any]{
                if let user = data["person"] as? [String:Any]{
                    UserModal.sharedInstance.createModal(dict: user)
                }
            }
            if let message = result["message"] as? String{
               onSuccess(message)
            }
        }) { (error) in
            onFailure(error)
        }
        
    }
}
