//
//  BadgeVM.swift
//  Reiki
//
//  Created by NewAgeSMB on 22/11/22.
//

import UIKit

class BadgeVM: NSObject {
    
    var badgeArray = [BadgeModal]()
    var isPageEmptyReached = false
    
    func getUserBadge(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.userBadge
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    if let userBadges = data["user_badges"] as? [[String:Any]]{
                        if userBadges.count == 0{
                            self.isPageEmptyReached = true
                        }else{
                            for i in userBadges{
                                let modal = BadgeModal()
                                modal.createModal(dict: i)
                                self.badgeArray.append(modal)
                            }
                        }
                        var seenBarValues = Set<String>()
                        let filteredArray = self.badgeArray.filter {
                            seenBarValues.insert($0.badge).inserted
                        }
                        self.badgeArray = filteredArray
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func getBadge(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.badge
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                self.badgeArray.removeAll()
                if let data = result["data"] as? [String:Any]{
                    if let badges = data["badges"] as? [[String:Any]]{
                        for i in badges{
                            let modal = BadgeModal()
                            modal.createBadgeModal(dict: i)
                            self.badgeArray.append(modal)
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
