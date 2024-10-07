//
//  LoginVM.swift
//  Showcase
//
//  Created by NewAgeSMB on 10/08/21.
//

import UIKit

class LoginVM: NSObject {
    
    var user = UserModal()
    var userArray = [UserModal]()
    
    func login(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        RequestManager.serverRequest(function: APIFunction.login, method: .post, parameters: urlParams, onSuccess: { result in
                if let error = result["error"] as? String{
                   if !(error.isEmpty){
                        if let message = result["message"] as? String{
                            onFailure(message)
                        }
                       return
                   }
                }
                print(result)
               
                if let data = result["data"] as? [String:Any]{
                    if let sessionId = data["token"] as? String{
                        UserDefaultsHelper().saveToken(token: sessionId)
                    }
                    if let sessionId = data["refresh_token"] as? String{
                        UserDefaultsHelper().saveRefreshToken(token: sessionId)
                    }
                    if let expiry = data["token_expiry"] as? String{
                        UserDefaultsHelper().saveTokenExpiryDate(date: expiry)
                    }
                    if let session = data["session_id"] as? String{
                        UserDefaultsHelper().saveSessionId(id: session)
                    }
                    if let user = data["user"] as? [String:Any]{
                        UserModal.sharedInstance.createModal(dict: user)
                    }
                    UserDefaultsHelper().saveUser(firstname: UserModal.sharedInstance.firstName, lastname: UserModal.sharedInstance.lastName, image: UserModal.sharedInstance.image)
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func getConfiguration(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
       
        RequestManager.serverRequestWithToken(function: APIFunction.configuration, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
            if let error = result["error"] as? String{
                if !(error.isEmpty){
                    onFailure(error)
                    return
                }
            }
            print(result)
            
            if let data = result["data"] as? [String:Any]{
                if let config = data["configurations"] as? [[String:Any]]{
                    var configArray = [Configuration]()
                    for i in config{
                        let point = anyToStringConverter(dict: i, key: "value")
                        let type = anyToStringConverter(dict: i, key: "name")
                        configArray.append(Configuration(point: point.isEmpty ? "0" : point, type: type))
                    }
                    UserModal.sharedInstance.configuration = configArray
                }
            }
            
            if let message = result["message"] as? String{
               onSuccess(message)
            }

        }, onFailure: {error in
            onFailure(error)
        })
        
    }
    
    func getUser(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
       
        RequestManager.serverRequestWithToken(function: APIFunction.user, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
            if let error = result["error"] as? String{
                if !(error.isEmpty){
                    onFailure(error)
                    return
                }
            }
            print(result)
            
            if let data = result["data"] as? [String:Any]{
                if let user = data["user"] as? [String:Any]{
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
    
    func getUserWithId(person:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.person + "/\(person)"
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
            if let error = result["error"] as? String{
                if !(error.isEmpty){
                    onFailure(error)
                    return
                }
            }
            print(result)
            
            if let data = result["data"] as? [String:Any]{
                if let user = data["person"] as? [String:Any]{
                   let modal = UserModal()
                    modal.createModal(dict: user)
                    self.user = modal
                }
            }
            
            if let message = result["message"] as? String{
               onSuccess(message)
            }

        }, onFailure: {error in
            onFailure(error)
        })
        
    }
    
    func findUser(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.person + "/find"
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
            if let error = result["error"] as? String{
                if !(error.isEmpty){
                    onFailure(error)
                    return
                }
            }
            print(result)
            
            if let data = result["data"] as? [String:Any]{
                if let user = data["person"] as? [String:Any]{
                   let modal = UserModal()
                    modal.createModal(dict: user)
                    self.user = modal
                }
            }
            
            if let message = result["message"] as? String{
               onSuccess(message)
            }

        }, onFailure: {error in
            onFailure(error)
        })
        
    }
    
    func changePassword(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequestWithToken(function: APIFunction.changePassword, method: .put, urlParams: urlParams, parameters: param, onSuccess: { result in
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
    
    func changePhone(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequestWithToken(function: APIFunction.userPhone, method: .put, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
               
                if let data = result["data"] as? [String:Any]{
                    if let sessionId = data["session_id"] as? String{
                        UserDefaults.standard.set(sessionId, forKey: "sessionId")
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func changePhoneVerify(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequestWithToken(function: APIFunction.userPhoneVerify, method: .put, urlParams: urlParams, parameters: param, onSuccess: { result in
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
    
    func changePhoneResendOTP(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequestWithToken(function: APIFunction.resendOTP, method: .post, urlParams: urlParams, parameters: param, onSuccess: { result in
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
    
    func updateProfile(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequestWithToken(function: APIFunction.personMe, method: .put, urlParams: urlParams, parameters: param, onSuccess: { result in
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
    
    func logoutSession(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequestWithToken(function: APIFunction.authSession, method: .post, urlParams: urlParams, parameters: param, onSuccess: { result in
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
    
    func deleteUserWithId(id:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = "user/me"
        RequestManager.serverRequestWithToken(function: function, method: .delete, urlParams: urlParams, parameters: param,isDelete: true, onSuccess: { result in
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
    
    func getPerson(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
       
        RequestManager.serverRequestWithToken(function: APIFunction.person, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
            if let error = result["error"] as? String{
                if !(error.isEmpty){
                    onFailure(error)
                    return
                }
            }
            print(result)
            
            if let data = result["data"] as? [String:Any]{
                self.userArray.removeAll()
                if let user = data["people"] as? [[String:Any]]{
                    for i in user{
                        let user = UserModal()
                        user.createModal(dict: i)
                        self.userArray.append(user)
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
    
    func logout(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = "auth/logout"
        RequestManager.serverRequestWithToken(function: function, method: .post, urlParams: urlParams, parameters: param,isDelete: true, onSuccess: { result in
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
