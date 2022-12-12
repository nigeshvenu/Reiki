//
//  LevelModal.swift
//  Reiki
//
//  Created by NewAgeSMB on 17/11/22.
//

import UIKit

class LevelModal: NSObject {

    var levelNo = ""
    var levelDate = ""
    var source = ""
    var levelDateSimple = ""
    var levelPoint = ""
    var log = [levelLogModal]()
}

class levelLogModal: NSObject{
    var levelDate = ""
    var levelPoint = ""
}
