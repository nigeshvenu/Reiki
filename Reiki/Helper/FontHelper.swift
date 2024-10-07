//
//  FontHelper.swift
//  prospect
//
//  Created by NewAgeSMB on 20/07/19.
//  Copyright © 2019 NewAgeSMB. All rights reserved.
//

import UIKit

enum FontStyle {
    case Regular
    case semiBold
    case Bold
    case Light
    case italic
    case medium
}

struct FontHelper {
    static func montserratFontSize(fontType:FontStyle,size: CGFloat) -> UIFont {
        switch fontType {
        case .semiBold:
            return UIFont(name: "Montserrat-SemiBold", size: size)!
        case .medium:
            return UIFont(name: "Montserrat-Medium", size: size)!
        case .Regular:
            return UIFont(name: "Montserrat-Regular", size: size)!
        case .Bold:
            return UIFont(name: "Montserrat-Bold", size: size)!
        case .Light:
            return UIFont(name: "Montserrat-Light", size: size)!
        case .italic:
            return UIFont(name: "SegoeUI-LightItalic", size: size)!
        }
    }
}

