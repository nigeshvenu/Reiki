//
//  HomePageVM.swift
//  Reiki
//
//  Created by NewAgeSMB on 31/10/22.
//

import UIKit

class HomePageVM: NSObject {
    
    var coinArray = [CoinModal]()
    
    func getUserCoin(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.userCoin
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                self.coinArray.removeAll()
                if let data = result["data"] as? [String:Any]{
                    if let favorites = data["user_coins"] as? [[String:Any]]{
                        for i in favorites{
                            let modal = CoinModal()
                            modal.createModal(dict: i)
                            self.coinArray.append(modal)
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
