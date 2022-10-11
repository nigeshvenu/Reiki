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
    
}
