//
//  SwiftMessagesHelper.swift
//  Showcase
//
//  Created by NewAgeSMB on 04/08/21.
//

import UIKit
import NotificationBannerSwift

class CustomBannerColors: BannerColorsProtocol {

    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
        case .danger:
            return UIColor.init(hexString: "#EB5050")
        // Your custom .danger color
        case .info: break        // Your custom .info color
        case .customView: break    // Your custom .customView color
        case .success:
            return UIColor.init(hexString: "#AA3270")
            // Your custom .success color
        case .warning: break    // Your custom .warning color
        }
        return UIColor(red:1.00, green:0.66, blue:0.16, alpha:1.00)
    }

}

class SwiftMessagesHelper: NSObject {

    /*static func showSwiftMessage(title:String,body:String,type:Theme){
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(type)
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        view.configureDropShadow()
        SwiftMessages.show(view: view)
        SwiftMessages.pauseBetweenMessages = 1.0
    }*/
    
    static func showSwiftMessage(title:String,body:String,type:BannerStyle ){
        NotificationBannerQueue.default.dismissAllForced()
        let banner = NotificationBanner(title: title,
                                        subtitle: body,
                                        style: type,
                                        colors: CustomBannerColors())
    
        banner.duration = 2.0
        banner.show()
       
    }
    
    
    /*static func showSwiftMessage(title:String,body:String,type:BannerStyle ){
        NotificationBannerQueue.default.dismissAllForced()
        let banner = FloatingNotificationBanner(title: title,
                                                subtitle: body,
                                                style: type)
        banner.duration = 2.0
        banner.show(queuePosition: .front,
                    bannerPosition: .top,
                    cornerRadius: 10,
                    shadowBlurRadius: 15)
    }*/
    
    
}
