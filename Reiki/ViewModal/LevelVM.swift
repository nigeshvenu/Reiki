//
//  LevelVM.swift
//  Reiki
//
//  Created by NewAgeSMB on 16/11/22.
//

import UIKit

class LevelVM: NSObject {
    
    var levelArray : Array<(key: String, value: Array<LevelModal>)>?
    var levelDictArray = [[String:Any]]()
    var isPageEmptyReached = false
    var levelCriteriaArray = [LevelModal]()
    
    func getUserLevel(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.userLevel
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    //self.levelArray = nil
                    if let userlevels = data["user_levels"] as? [[String:Any]]{
                        if userlevels.count == 0{
                            self.isPageEmptyReached = true
                        }else{
                            self.levelDictArray += userlevels
                            self.createUserLevelArray(userLevelArray: self.levelDictArray)
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
    
    func createUserLevelArray(userLevelArray:[[String:Any]]){
        var levelArray = [LevelModal]()
        for i in userLevelArray{
            let levelModal = LevelModal()
            if let level = i["level"] as? [String:Any]{
                levelModal.levelNo = anyToStringConverter(dict: level, key: "level_number")
            }
            levelModal.levelPoint = anyToStringConverter(dict: i, key: "point")
            let date = anyToStringConverter(dict: i, key: "created_at")
            levelModal.levelDateSimple = date.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "MMMM d")
            let date1 = anyToStringConverter(dict: i, key: "created_at")
            levelModal.levelDate = date1.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "MM/dd/yyyy")
            levelModal.source = anyToStringConverter(dict: i, key: "source")
            levelArray.append(levelModal)
        }
        let groupByLevel = Dictionary(grouping: levelArray) { (device) -> String in
            return device.levelNo
        }
        
        let sorted = groupByLevel.sorted(by: { Int($0.0)! > Int($1.0)!})
        self.levelArray = sorted
    }
    
    func resetLevel(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.userReset
        RequestManager.serverRequestWithToken(function: function, method: .put, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                   
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func getLevels(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.level
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                self.levelCriteriaArray.removeAll()
                if let data = result["data"] as? [String:Any]{
                    if let badges = data["levels"] as? [[String:Any]]{
                        for i in badges{
                            let modal = LevelModal()
                            modal.levelNo = anyToStringConverter(dict: i, key: "level_number")
                            modal.levelName = anyToStringConverter(dict: i, key: "level_name")
                            modal.levelShape = anyToStringConverter(dict: i, key: "shape")
                            modal.requiredPoint = anyToStringConverter(dict: i, key: "required_point")
                            self.levelCriteriaArray.append(modal)
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
}
