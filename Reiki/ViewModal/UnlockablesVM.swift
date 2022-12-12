//
//  UnlockablesVM.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/10/22.
//

import UIKit

class UnlockablesVM: NSObject {

    var customGearArray = [CustomGearCategoryModal]()
    var customGearSubArray = [CustomGearSubCategoryModal]()
    var themeArray = [ThemeModal]()
    var userThemeId = ""
    var isPageEmptyReached = false
    var purchaseHistoryArray = [ItemModal]()
    
    func getCustomGearCategory(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.customGearCategory
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
            self.customGearArray.removeAll()
                if let data = result["data"] as? [String:Any]{
                    if let customGear = data["custom_gear_categories"] as? [[String:Any]]{
                        for i in customGear{
                            let catId = anyToStringConverter(dict: i, key: "category_id")
                            if catId.isEmpty{
                                let modal = CustomGearCategoryModal()
                                modal.categoryId = anyToStringConverter(dict: i, key: "id")
                                modal.categoryIdInt = Int(anyToStringConverter(dict: i, key: "id")) ?? 0
                                modal.categoryName = anyToStringConverter(dict: i, key: "name")
                                self.customGearArray.append(modal)
                            }
                        }
                        if let gear = self.customGearArray.first{
                            gear.isSelected = true
                        }
                        self.customGearArray = self.customGearArray.sorted(by: { $0.categoryIdInt < $1.categoryIdInt })
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func getCustomGearCategorySub(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.customGearSubCategory
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                self.customGearSubArray.removeAll()
                if let data = result["data"] as? [String:Any]{
                    if let customGear = data["custom_gears"] as? [String:Any]{
                        for (key, value) in customGear{
                            if let valueArray = value as? [[String:Any]]{
                                let modal = CustomGearSubCategoryModal()
                                var itemArray = [ItemModal]()
                                for i in valueArray{
                                    if let sub = i["custom_gear_sub_category"] as? [String:Any]{
                                        modal.name = anyToStringConverter(dict: sub, key: "name")
                                        modal.subCategoryId = anyToStringConverter(dict: sub, key: "id")
                                        modal.subCategoryIdInt = Int(anyToStringConverter(dict: sub, key: "id"))!
                                        modal.categoryId = anyToStringConverter(dict: sub, key: "category_id")
                                    }
                                    let itemModal = ItemModal()
                                    itemModal.name = anyToStringConverter(dict: i, key: "name")
                                    itemModal.image = anyToStringConverter(dict: i, key: "image_url")
                                    itemModal.coin = anyToStringConverter(dict: i, key: "required_coin")
                                    itemModal.itemId = anyToStringConverter(dict: i, key: "id")
                                    if let user_custom_gear = i["user_custom_gear"] as? [String:Any]{
                                        itemModal.isUnlocked = true
                                        itemModal.isApplied = anyToBoolConverter(dict: user_custom_gear, key: "applied")
                                        itemModal.userCustomGearId = anyToStringConverter(dict: user_custom_gear, key: "id")
                                    }
                                    itemArray.append(itemModal)
                                }
                                modal.itemArray = itemArray
                                self.customGearSubArray.append(modal)
                            }
                        }
                        self.customGearSubArray = self.customGearSubArray.sorted(by: { $0.subCategoryIdInt < $1.subCategoryIdInt })
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func getThemes(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.theme
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                self.themeArray.removeAll()
                if let data = result["data"] as? [String:Any]{
                    if let themes = data["themes"] as? [[String:Any]]{
                        for i in themes{
                            let modal = ThemeModal()
                            modal.image = anyToStringConverter(dict: i, key: "image_url")
                            modal.coin = anyToStringConverter(dict: i, key: "required_coin")
                            modal.themeId = anyToStringConverter(dict: i, key: "id")
                            if let userTheme = i["user_theme"] as? [String:Any]{
                                modal.isUnlocked = true
                                modal.isApplied = anyToBoolConverter(dict: userTheme, key: "applied")
                                modal.userThemeId = anyToStringConverter(dict: userTheme, key: "id")
                            }
                            self.themeArray.append(modal)
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
    
    func getUserThemes(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.userTheme
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                self.themeArray.removeAll()
                if let data = result["data"] as? [String:Any]{
                    if let themes = data["user_themes"] as? [[String:Any]]{
                        for i in themes{
                            if let userTheme = i["theme"] as? [String:Any]{
                                let modal = ThemeModal()
                                modal.themeUrl = anyToStringConverter(dict: userTheme, key: "image_url")
                                self.themeArray.append(modal)
                            }
                        }
                        //UserModal.sharedInstance.userThemes = self.themeArray
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func unlockThemes(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.userTheme
        RequestManager.serverRequestWithToken(function: function, method: .post, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    if let userTheme = data["user_theme"] as? [String:Any]{
                        self.userThemeId = anyToStringConverter(dict: userTheme, key: "id")
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func removeTheme(id:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.userTheme + "/" + id
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
    
    func updateUserTheme(id:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.userTheme + "/" + id
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
    
    func resetUserTheme(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.userThemeReset
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
    
    
    func unlockCustomGear(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.user_custom_gear
        RequestManager.serverRequestWithToken(function: function, method: .post, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    if let userTheme = data["user_theme"] as? [String:Any]{
                        //self.userThemeId = anyToStringConverter(dict: userTheme, key: "id")
                    }
                }
                if let message = result["message"] as? String{
                    onSuccess(message)
                }
           }, onFailure: {error in
               onFailure(error)
           })
           
       }
    
    func updateCustomGear(id:String,urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.user_custom_gear + "/" + id
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
    
    func getPurchaseHistory(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.purchaseHistory
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    if let purchaseHistory = data["purchase_histories"] as? [[String:Any]]{
                        if purchaseHistory.count == 0{
                            self.isPageEmptyReached = true
                        }else{
                            for i in purchaseHistory{
                                let modal = ItemModal()
                                if let customGear = i["custom_gear"] as? [String:Any]{
                                    modal.name = anyToStringConverter(dict: customGear, key: "name")
                                    modal.image = anyToStringConverter(dict: customGear, key: "image_url")
                                    modal.coin = anyToStringConverter(dict: customGear, key: "required_coin")
                                }
                                if let customGear = i["theme"] as? [String:Any]{
                                    modal.name = "Theme"
                                    modal.image = anyToStringConverter(dict: customGear, key: "image_url")
                                    modal.coin = anyToStringConverter(dict: customGear, key: "required_coin")
                                }
                                let date = anyToStringConverter(dict: i, key: "created_at")
                                modal.createdDate = date.UTCToLocal(incomingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outGoingFormat: "MMMM d yyyy")
                                self.purchaseHistoryArray.append(modal)
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
    
    func getCustomGear(urlParams:[String:Any]?,param:[String:Any]?,onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        let function = APIFunction.user_custom_gear
        RequestManager.serverRequestWithToken(function: function, method: .get, urlParams: urlParams, parameters: param, onSuccess: { result in
               if let error = result["error"] as? String{
                   if !(error.isEmpty){
                       onFailure(error)
                       return
                   }
               }
                print(result)
                if let data = result["data"] as? [String:Any]{
                    self.purchaseHistoryArray.removeAll()
                    if let customGearsArray = data["user_custom_gears"] as? [[String:Any]]{
                        for i in customGearsArray{
                            if let customGear = i["custom_gear"] as? [String:Any]{
                                let modal = ItemModal()
                                modal.name = anyToStringConverter(dict: customGear, key: "name")
                                modal.image = anyToStringConverter(dict: customGear, key: "image_url")
                                self.purchaseHistoryArray.append(modal)
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

