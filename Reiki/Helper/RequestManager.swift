//
//  RequestManager.swift
//  StatChat
//
//  Created by NewAgeSMB/Abhijith on 07/09/17.
//  Copyright © 2017 NewAgeSMB/Abhijith. All rights reserved.
//

import UIKit
import Alamofire

class RequestManager: NSObject {
    
    static var authTokenKey = "AuthToken"
    static var refreshTokenKey = "RefreshToken"
    static var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    //MARK:- GET Server Request without Token
    
    class func serverRequest(baseUrl:String = APIUrl.BaseURL,function: String, method: HTTPMethod, parameters: [String: Any]?, onSuccess: @escaping ([String:Any]) -> Void, onFailure: @escaping (String) -> Void) {
        
        let baseUrl = "\(APIUrl.BaseURL)\(function)"
        
        AF.request(baseUrl, method: method, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            //let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
            //print("Response String: \(String(describing: responseString))")
            switch(response.result) {
            case .success(_):
                if let json = response.value{
                    print(json)
                    let responseDic = json as! [String:Any]
                    let message = anyToStringConverter(dict: responseDic, key: "message")
                    if response.response?.statusCode != nil && (200..<300).contains(response.response!.statusCode){
                        onSuccess(responseDic)
                    }else{
                        onFailure(message.isEmpty ? "Error" : message)
                    }
                }
                break
            case .failure(_):
                print(response.error!)
                if response.error!.isSessionTaskError{
                    onFailure(MessageHelper.ErrorMessage.internetOffline)
                }else{
                    onFailure((response.error?.localizedDescription) ?? "")
                }
                break
            }
        }
    }
    
    class func serverRequestNewToken(onSuccess: @escaping ([String:Any]) -> Void, onFailure: @escaping (String) -> Void) {
        
        let baseUrl = "\(APIUrl.BaseURL)\(APIFunction.token)"
        let paramater = ["token":UserDefaultsHelper().getToken(),
                         "refresh_token":UserDefaultsHelper().getRefreshToken()]
        AF.request(baseUrl, method: .post, parameters: paramater, encoding: JSONEncoding.default).responseJSON { response in
            //let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
            //print("Response String: \(String(describing: responseString))")
            switch(response.result) {
            case .success(_):
                if let json = response.value{
                    print(json)
                    let responseDic = json as! [String:Any]
                    let message = anyToStringConverter(dict: responseDic, key: "message")
                    if response.response?.statusCode != nil && (200..<300).contains(response.response!.statusCode){
                        if let data = responseDic["data"] as? [String:Any]{
                            if let sessionId = data["token"] as? String{
                                UserDefaultsHelper().saveToken(token: sessionId)
                            }
                            if let expiry = data["token_expiry"] as? String{
                                UserDefaultsHelper().saveTokenExpiryDate(date: expiry)
                            }
                        }
                        onSuccess(responseDic)
                    }else if response.response?.statusCode != nil && (response.response!.statusCode) == 401{
                        onFailure(MessageHelper.ErrorMessage.userSessionExpired)
                        self.goToRootVC()
                    }else{
                        onFailure(message)
                    }
                }
                break
            case .failure(_):
                print(response.error!)
                if response.error!.isSessionTaskError{
                    onFailure(MessageHelper.ErrorMessage.internetOffline)
                }else{
                    onFailure((response.error?.localizedDescription)!)
                }
                break
            }
        }
    }
    
    //MARK:- Server Request with Token
    
    class func serverRequestWithToken(baseUrl:String = APIUrl.BaseURL ,function: String, method: HTTPMethod, urlParams:[String:Any]?,parameters: [String: Any]?,isDelete:Bool = false, onSuccess: @escaping ([String:Any]) -> Void, onFailure: @escaping (String) -> Void) {
      
            let headers : HTTPHeaders = [
                "Authorization": "Bearer \(UserDefaultsHelper().getToken())",
                "Content-Type": "application/json"
            ]
            let baseUrl = self.generateQueryUrl(path: function, params: urlParams).replacingOccurrences(of: "+", with: "%2B")
            
            AF.request(baseUrl, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                //let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                //print("Response String: \(String(describing: responseString))")
                print("***  Base URL :\n \(response.request?.url as Any)\n")
                print("***  Http Body :\n \(NSString(data: (response.request?.httpBody) ?? Data(), encoding: String.Encoding.utf8.rawValue) as Any)")
               
                switch(response.result) {
                case .success(_):
                    if let json = response.value{
                        let responseDic = json as! [String:Any]
                        if response.response?.statusCode != nil && (200..<300).contains(response.response!.statusCode){
                            onSuccess(responseDic)
                            return
                        }
                        if response.response?.statusCode != nil && ((response.response!.statusCode) == 400 || (response.response!.statusCode) == 500){//Bad request
                            let message = anyToStringConverter(dict: responseDic, key: "message")
                            let error = anyToStringConverter(dict: responseDic, key: "error")
                            if error == "CardFinderTimerError"{
                                /*let hour = message.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "h")
                                let min = message.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "mm")
                                let sec = message.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "ss")
                                let format = message.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "a")
                                let dateString = "\(hour):\(min):\(sec) \(format)"*/
                                let dateString = message.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "MM-dd-yyyy h:mm:ss")
                                let currentDate = Date().toString(dateFormat: "MM-dd-yyyy h:mm:ss")
                                let currentDateAsDate = currentDate.date(format: "MM-dd-yyyy h:mm:ss") ?? Date()
                                let dateAsDate = dateString.date(format: "MM-dd-yyyy h:mm:ss") ?? Date()
                                let dateDifference = dateAsDate.offsetFrom(date: currentDateAsDate)
                                onFailure("Please try again at \(dateDifference)")
                            }else{
                                onFailure(message)
                            }
                            return
                        }else if response.response?.statusCode != nil && (response.response!.statusCode) == 404{
                            let message = anyToStringConverter(dict: responseDic, key: "message")
                            onFailure(message)
                        }else if response.response?.statusCode != nil && (response.response!.statusCode) == 401{
                            //Status code 401: Token expired or invalid
                            serverRequestNewToken { (message) in
                                self.serverRequestWithToken(function: function, method: method, urlParams: urlParams, parameters: parameters, onSuccess: onSuccess, onFailure: onFailure)
                                
                            } onFailure: { (error) in
                                onFailure(error)
                            }
                            
                        }else{
                            //Status code 403: User deleted, blocked
                            onFailure(isDelete ? "Account deleted successfully" : MessageHelper.ErrorMessage.userSessionExpired)
                            self.goToRootVC()
                        }
                        break
                    }
                case .failure(_):
                    print(response.error!)
                    if response.error!.isSessionTaskError{
                        onFailure(MessageHelper.ErrorMessage.internetOffline)
                    }else{
                        onFailure((response.error?.localizedDescription)!)
                    }
                    break
              }
         }
  
    }
    
   
    class func multipartRequest(function: String,param:[String:Any]?,removeImage:Bool,image:UIImage?,fileName:String,method:HTTPMethod = .put,onSuccess: @escaping ([String:Any]) -> Void, onFailure: @escaping (String) -> Void){
        
        let headers : HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaultsHelper().getToken())",
            "Content-Type": "application/json"
        ]
        let baseUrl = "\(APIUrl.BaseURL)\(function)"
        
        let upload = AF.upload(multipartFormData: { (multipartFormData) in
                  
            for (key, value) in param ?? [:] {
                if let val = value as? Int{
                    multipartFormData.append("\(val)".data(using: String.Encoding.utf8)!, withName: key)
                }else if let val = value as? Bool{
                    multipartFormData.append(String(val).data(using: String.Encoding.utf8)!, withName: key)
                }else if let valu = value as? String{
                    multipartFormData.append((valu).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            if removeImage{
                    multipartFormData.append(("").data(using: String.Encoding.utf8)!, withName: fileName)
            }else{
                if image != nil{
                    if let imageData = image!.jpegData(compressionQuality: 1){
                       multipartFormData.append(imageData, withName: fileName, fileName: fileName + ".png", mimeType: "image/png")
                    }
                }
            }
            
        },to: URL.init(string: baseUrl)!, usingThreshold: UInt64.init(),
                method: method,
                headers: headers).responseJSON{ response in
                    switch(response.result) {
                    case .success(_):
                        if let json = response.value{
                            let responseDic = json as! [String:Any]
                            if response.response?.statusCode != nil && (200..<300).contains(response.response!.statusCode){
                                onSuccess(responseDic)
                                return
                            }
                            if response.response?.statusCode != nil && ((response.response!.statusCode) == 400 || (response.response!.statusCode) == 500){//Bad request
                                let message = anyToStringConverter(dict: responseDic, key: "message")
                                onFailure(message)
                                return
                            }else if response.response?.statusCode != nil && (response.response!.statusCode) == 404{
                                let message = anyToStringConverter(dict: responseDic, key: "message")
                                onFailure(message)
                            }else if response.response?.statusCode != nil && (response.response!.statusCode) == 401{
                                //Status code 401: Token expired or invalid
                                serverRequestNewToken { (message) in
                                    multipartRequest(function: function, param: param, removeImage: removeImage, image: image, fileName: fileName, method: method, onSuccess: onSuccess, onFailure: onFailure)
                                    
                                } onFailure: { (error) in
                                    onFailure(error)
                                }
                                
                            }else{
                                //Status code 403: User deleted, blocked
                                onFailure(MessageHelper.ErrorMessage.userSessionExpired)
                                self.goToRootVC()
                            }
                            break
                        }
                    case .failure(_):
                        print(response.error!)
                        if response.error!.isSessionTaskError{
                            onFailure(MessageHelper.ErrorMessage.internetOffline)
                        }else{
                            onFailure((response.error?.localizedDescription)!)
                        }
                        break
                    }
              }
        upload.uploadProgress { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        
    }
    
    class func clearSession(){
        AppDelegate.shared.showLoading(isShow: true)
        LoginVM().logoutSession(urlParams: nil, param: nil, onSuccess: { message in
        }, onFailure: { error in
        })
    }
    
    class func goToRootVC(){
        //clearSession()
        UserDefaultsHelper().clearUserdefaults()
        UserModal.sharedInstance.reset()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
            if let VC = appDelegate.window?.rootViewController as? UINavigationController{
                let controllers = VC.viewControllers
                var isFound = false
                for vc in controllers {
                  if vc.isKind(of: LoginPageVC.self) {
                      isFound = true
                      VC.popToViewController(vc, animated: true)
                  }
                }
                if !isFound{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginPageVC")
                    VC.viewControllers.insert(vc, at: 1)
                }
            }
        }
    }
    
    class func generateQueryUrl(path:String,params:[String:Any]?)->String{

        var url = "\(APIUrl.BaseURL)\(path)?"
        if params == nil{return url}
        
        if let id = params?["id"] as? String{
           url += "\(id)&"
        }
        if let search = params?["search"] as? String{
           url += "search=\(search)&"
        }
        if let limit = params?["limit"] as? Int{
           url += "limit=\(limit)&"
        }
        if let offset = params?["offset"] as? Int{
           url += "offset=\(offset)&"
        }
        if let active = params?["active"] as? Bool{
           url += "active=\(active)&"
        }
        if let withDeleted = params?["withDeleted"] as? Bool{
           url += "withDeleted=\(withDeleted)&"
        }
        if let sort = params?["sort"] as? NSArray{
            if sort.count > 0{
                let jsonString = jsonToString(json: sort)
                if !(jsonString.isEmpty){
                   url += "sort=\(jsonString)&"
                }
            }
        }
        if let sort = params?["populate"] as? NSArray{
            if sort.count > 0{
                let jsonString = jsonToString(json: sort)
                if !(jsonString.isEmpty){
                   url += "populate=\(jsonString)&"
                }
            }
        }
        if let sort = params?["location"] as? NSArray{
            if sort.count > 0{
                let jsonString = jsonToString(json: sort)
                if !(jsonString.isEmpty){
                   url += "location=\(jsonString)&"
                }
            }
        }
        if let sort = params?["where"] as? NSDictionary{
            let jsonString = jsonToString(json: sort)
            if !(jsonString.isEmpty){
                url += "where=\(jsonString)&"
            }
        }
       
        if let select = params?["select"] as? NSArray{
            if select.count > 0{
                let jsonString = jsonToString(json: select)
                if !(jsonString.isEmpty){
                   url += "select=\(jsonString)&"
                }
            }
        }
        
        if let from = params?["from"] as? String{
           url += "from=\(from)&"
        }
        if let to = params?["to"] as? String{
           url += "to=\(to)&"
        }
        if let type = params?["type"] as? String{
           url += "type=\(type)&"
        }
        if let business = params?["business"] as? String{
           url += "business=\(business)&"
        }
        return url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? url
    }
    
    class func jsonToString(json: AnyObject)->String{
       
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString ?? ""
        } catch{
            return ""
        }
    }
    
}

extension Dictionary {
    var jsonStringRepresentaiton: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}
