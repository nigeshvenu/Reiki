//
//  CustomGearSubCategoryModal.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/10/22.
//

import UIKit

class CustomGearSubCategoryModal: NSObject {
    var name = ""
    var subCategoryId = ""
    var subCategoryIdInt = 0
    var categoryId = ""
    var itemArray = [ItemModal]()
}

class ItemModal{
    var id = ""
    var name = ""
    var image = ""
    var animationUrl = ""
    var requiredCoin = ""
    var itemId = ""
    var userCustomGearId = ""
    var isUnlocked = false
    var isApplied = false
    var createdDate = ""
    var completedPlaying = false
    var isDeleted = ""
    var isActive = true
    var levelNo = ""
}
