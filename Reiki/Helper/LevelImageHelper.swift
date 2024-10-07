//
//  LevelImageHelper.swift
//  Reiki
//
//  Created by NewAgeSMB on 21/11/22.
//

import UIKit

class LevelImageHelper: NSObject {
    static func getImage(leveNumber:String) -> UIImage? {
        switch leveNumber {
        case "1":
            return UIImage(named: "Level1-Traingle")
        case "2":
            return UIImage(named: "Level2-Traingle")
        case "3":
            return UIImage(named: "Level3-Traingle")
        case "4":
            return UIImage(named: "Level4-Square")
        case "5":
            return UIImage(named: "Level5-Square")
        case "6":
            return UIImage(named: "Level6-Square")
        case "7":
            return UIImage(named: "Level7-Circle")
        case "8":
            return UIImage(named: "Level8-Circle")
        case "9":
            return UIImage(named: "Level9-Circle")
        case "10":
            return UIImage(named: "Level10-Star")
        case "11":
            return UIImage(named: "Level11-Star")
        case "12":
            return UIImage(named: "Level12-Star")
        default:
            return  nil
        }
    }
}
