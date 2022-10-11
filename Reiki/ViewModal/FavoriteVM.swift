//
//  FavoriteVM.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/10/22.
//

import UIKit

class FavoriteVM: NSObject {
    
    var favoritesArray = [FavoriteModal]()
    func getFavorite(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.favoriteActivity
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                self.favoritesArray.removeAll()
                if let data = result["data"] as? [String:Any]{
                    if let favorites = data["favorites"] as? [[String:Any]]{
                        for i in favorites{
                            let modal = FavoriteModal()
                            modal.createModal(dict: i)
                            self.favoritesArray.append(modal)
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
