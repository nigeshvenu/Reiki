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
    var name = ""
    var image = ""
    var coin = ""
    var itemId = ""
}
