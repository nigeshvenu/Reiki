//
//  CardFinderVM.swift
//  Reiki
//
//  Created by NewAgeSMB on 20/10/22.
//

import UIKit

class CardFinderVM: NSObject {
    var event : EventModal?
    var cardArray = [CardModal]()
    
    func getCardFinder(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.card
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    if let activity = data["activity"] as? [String:Any]{
                        let modal = EventModal()
                        modal.createModal(dict: activity)
                        self.event = modal
                    }
                    if let cards = data["cards"] as? [[String:Any]]{
                        self.cardArray.removeAll()
                        for i in cards{
                            let modal = CardModal()
                            modal.createModal(dict: i)
                            self.cardArray.append(modal)
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
