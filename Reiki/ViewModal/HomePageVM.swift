//
//  HomePageVM.swift
//  Reiki
//
//  Created by NewAgeSMB on 31/10/22.
//

import UIKit

class HomePageVM: NSObject {
    
    var coinArray = [CoinModal]()
    var cardHistoryArray = [CardHistoryModal]()
    var isPageEmptyReached = false
    
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
    
    func getUserAllCoins(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.userCoinAll
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    if let userCoins = data["user_coins"] as? [[String:Any]]{
                        if userCoins.count == 0{
                            self.isPageEmptyReached = true
                        }else{
                            for i in userCoins{
                                let cardModal = CardHistoryModal()
                                let createdDate = anyToStringConverter(dict: i, key: "created_at")
                                cardModal.createdDate = createdDate.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "d-MMMM-yyyy")
                                if let card = i["card"] as? [String:Any]{
                                    let modal = CardModal()
                                    modal.createModal(dict: card)
                                    cardModal.card = modal
                                    self.cardHistoryArray.append(cardModal)
                                }
                                if let activity = i["activity"] as? [String:Any]{
                                    let modal = EventModal()
                                    modal.createModal(dict: activity)
                                    cardModal.activity = modal
                                    self.cardHistoryArray.append(cardModal)
                                }
                            }
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
