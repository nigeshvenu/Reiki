//
//  SignupVM.swift
//  Reiki
//
//  Created by NewAgeSMB on 30/08/22.
//

import UIKit

class SignupVM: NSObject {
    
    func validatePhone(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequest(function: APIFunction.phoneValidation, method: .post, parameters: urlParams, onSuccess: { result in
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
    
    func forgotPwd(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequest(function: APIFunction.forgotPassword, method: .post, parameters: urlParams, onSuccess: { result in
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


    func verifyOTP(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequest(function: APIFunction.verifyOTP, method: .post, parameters: urlParams, onSuccess: { result in
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
    
    func resendOTP(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequest(function: APIFunction.resendOTP, method: .post, parameters: urlParams, onSuccess: { result in
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
    
    func signup(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequest(function: APIFunction.signup, method: .post, parameters: urlParams, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
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
    
    func resetPassword(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
           
        RequestManager.serverRequest(function: APIFunction.resetPassword, method: .post, parameters: urlParams, onSuccess: { result in
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
}
