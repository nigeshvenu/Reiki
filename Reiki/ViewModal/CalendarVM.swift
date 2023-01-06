//
//  CalendarVM.swift
//  Reiki
//
//  Created by NewAgeSMB on 26/09/22.
//

import UIKit

class CalendarVM: NSObject {

    var event = EventModal()
    var eventArray = [EventModal]()
    var openEventArray = [EventModal]()
    var favoriteId = ""
    var isFavorite = false
    var isActivityCompleted = false
    var card : CardModal?
    var useractivityId = ""
    func getCalendarActivityList(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
       
        RequestManager.serverRequestWithToken(function: APIFunction.calendarActivityList, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
            if let error = result["error"] as? String{
                if !(error.isEmpty){
                    onFailure(error)
                    return
                }
            }
            print(result)
            
            if let data = result["data"] as? [String:Any]{
                self.eventArray.removeAll()
                self.openEventArray.removeAll()
                if let calendarActivity = data["calendar_activity_lists"] as? [[String:Any]]{
                    for i in calendarActivity{
                        let modal = EventModal()
                        modal.createModal(dict: i)
                        modal.eventType = .publicType
                        self.eventArray.append(modal)
                    }
                }
                if let calendarActivity = data["open"] as? [[String:Any]]{
                    for i in calendarActivity{
                        //if let activity = i["activity"] as? [String:Any]{
                            let modal = EventModal()
                            modal.createModal(dict: i)
                            modal.eventType = .publicType
                            self.openEventArray.append(modal)
                       // }
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
    
    func getCustomActivityList(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
       
        RequestManager.serverRequestWithToken(function: APIFunction.user_custom_activity, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
            if let error = result["error"] as? String{
                if !(error.isEmpty){
                    onFailure(error)
                    return
                }
            }
            print(result)
            
            if let data = result["data"] as? [String:Any]{
                self.eventArray.removeAll()
                if let calendarActivity = data["user_custom_activities"] as? [[String:Any]]{
                    for i in calendarActivity{
                        let modal = EventModal()
                        modal.createModal(dict: i)
                        modal.eventType = .custom
                        self.eventArray.append(modal)
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
    
    func getActivity(id:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.calendarActivity + "/" + id
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
               
                if let data = result["data"] as? [String:Any]{
                    if let activity = data["calendar_activity_list"] as? [String:Any]{
                        let modal = EventModal()
                        modal.createModal(dict: activity)
                        modal.eventType = .publicType
                        self.event = modal
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func getCustomActivity(id:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.user_custom_activity + "/" + id
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    if let user_custom_activity = data["user_custom_activity"] as? [String:Any]{
                        let modal = EventModal()
                        modal.createModal(dict: user_custom_activity)
                        modal.eventType = .custom
                        self.event = modal
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
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
               
                if let data = result["data"] as? [String:Any]{
                    self.isFavorite = false
                    self.favoriteId = ""
                    if let favorite = (data["favorites"] as? [[String:Any]])?.first{
                        self.isFavorite = true
                        self.favoriteId = anyToStringConverter(dict: favorite, key: "id")
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func favoriteActivity(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
       
        RequestManager.serverRequestWithToken(function: APIFunction.favoriteActivity, method: .post, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
               
                if let data = result["data"] as? [String:Any]{
                    if let favorite = data["favorite"] as? [String:Any]{
                        self.favoriteId = anyToStringConverter(dict: favorite, key: "id")
                        self.isFavorite = true
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func removeFavoriteActivity(id:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.favoriteActivity + "/" + id
        RequestManager.serverRequestWithToken(function: function, method: .delete, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    self.favoriteId = ""
                    self.isFavorite = false
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func getUserActivity(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
       
        RequestManager.serverRequestWithToken(function: APIFunction.user_activity, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
               
                if let data = result["data"] as? [String:Any]{
                    if let activity = (data["user_activities"] as? [[String:Any]])?.first{
                        let timeZone = anyToStringConverter(dict: activity, key: "timezone")
                        if timeZone.isEmpty{
                            self.isActivityCompleted = false
                        }else{
                            self.isActivityCompleted = true
                        }
                        self.event.journal = anyToStringConverter(dict: activity, key: "journal")
                        self.event.userActivityId = anyToStringConverter(dict: activity, key: "_id")
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func createUserActivity(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
       
        RequestManager.serverRequestWithToken(function: APIFunction.user_activity, method: .post, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
               
                if let data = result["data"] as? [String:Any]{
                    if let userActivity = data["user_activity"] as? [String:Any]{
                        self.useractivityId = anyToStringConverter(dict: userActivity, key: "_id")
                        if let card = userActivity["card"] as? [String:Any]{
                            let modal = CardModal()
                            modal.createModal(dict: card)
                            self.card = modal
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
    
    func editUserActivity(id:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.user_activity + "/" + id
        RequestManager.serverRequestWithToken(function: function, method: .put, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    if let userActivity = data["user_activity"] as? [String:Any]{
                        if let card = userActivity["card"] as? [String:Any]{
                            let modal = CardModal()
                            modal.createModal(dict: card)
                            self.card = modal
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
    
    func updateCustomUserActivity(id:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.user_custom_activity + "/" + id
        RequestManager.serverRequestWithToken(function: function, method: .put, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
               
                if let data = result["data"] as? [String:Any]{
                    if let userActivity = data["user_custom_activity"] as? [String:Any]{
                        if let card = userActivity["card"] as? [String:Any]{
                            let modal = CardModal()
                            modal.createModal(dict: card)
                            self.card = modal
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
    
    func userActivityView(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
       
        RequestManager.serverRequestWithToken(function: APIFunction.user_activity_view, method: .post, urlParams: urlParams, parameters: param, onSuccess: { result in
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
    
}

//
extension CalendarVM{
    
    func createCustomActivity(param:[String:Any]?,removeImage:Bool,image:UIImage?,fileName:String,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        
        RequestManager.multipartRequest(function: APIFunction.user_custom_activity, param: param, removeImage: removeImage, image: image, fileName: fileName,method: .post, onSuccess: { (result) in
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
        }) { (error) in
            onFailure(error)
        }
        
    }
    
    func updateCustomActivity(id:String,param:[String:Any]?,removeImage:Bool,image:UIImage?,fileName:String,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.user_custom_activity + "/" + id
        RequestManager.multipartRequest(function: function, param: param, removeImage: removeImage, image: image, fileName: fileName,method: .put, onSuccess: { (result) in
            if let error = result["error"] as? String{
                if !(error.isEmpty){
                    onFailure(error)
                    return
                }
            }
            print(result)
            if let data = result["data"] as? [String:Any]{
                if let userActivity = data["user_custom_activity"] as? [String:Any]{
                    let modal = EventModal()
                    modal.createModal(dict: userActivity)
                    modal.eventType = .custom
                    self.event = modal
                }
            }
            if let message = result["message"] as? String{
               onSuccess(message)
            }
        }) { (error) in
            onFailure(error)
        }
        
    }
    
    func deleteCustomActivity(id:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.user_custom_activity + "/" + id
        RequestManager.serverRequestWithToken(function: function, method: .delete, urlParams: urlParams, parameters: param, onSuccess: { result in
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
    
}
