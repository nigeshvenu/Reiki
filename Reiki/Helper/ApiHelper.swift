//
//  ApiHelper.swift
//  goGroceryCart
//
//  Created by NewAgeSMB/Nigesh on 5/12/18.
//  Copyright © 2018 NewAgeSMB. All rights reserved.
//

import UIKit

struct APIUrl {
    
    #if DEBUG
    //Dev
    //static let BaseURL = "https://apps-dev.myreikicalendar.com/"

    //Staging
    static let BaseURL = "https://apps-staging.myreikicalendar.com/"
   
    //Production
   
    #else
    
    //Dev
    //static let BaseURL = "https://apps-dev.myreikicalendar.com/"
     
    //Staging
    static let BaseURL = "https://apps-staging.myreikicalendar.com/"
   
    //Production
    
    #endif
    
}

struct Key{
#if DEBUG
    //Dev
    //static let placesKey = "AIzaSyB23TUxw8OnaZ3h6LmIWu7--OYkPVyY_lw"
    //Staging
    //static let placesKey = "AIzaSyB23TUxw8OnaZ3h6LmIWu7--OYkPVyY_lw"
    //Production
    static let placesKey = "AIzaSyCAheDBbeg_qS-7qDOjVR06532vauCkvv8"
    
#else
    //Dev
    //static let placesKey = "AIzaSyB23TUxw8OnaZ3h6LmIWu7--OYkPVyY_lw"
    //Staging
    //static let placesKey = "AIzaSyB23TUxw8OnaZ3h6LmIWu7--OYkPVyY_lw"
    //Production
    static let placesKey = "AIzaSyCAheDBbeg_qS-7qDOjVR06532vauCkvv8"
    
#endif
    
}

struct APIFunction {
    static var user_card = "user_card"
    static var phoneValidation = "auth/phone/validate"
    static var verifyOTP = "auth/otp/verify"
    static var resendOTP = "auth/otp/send"
    static var signup = "auth/signup"
    static var terms = "page/terms/webview"
    static var privacy = "page/privacy/webview"
    static var faq = "faq"
    static var login = "auth/local"
    static var token = "auth/token"
    static var forgotPassword = "auth/password/forgot"
    static var resetPassword = "auth/password/reset"
    static var changePassword = "user/password"
    static var userPhone = "user/phone"
    static var userPhoneVerify = "user/phone/verify"
    static var userTheme = "user_theme"
    static var user_custom_gear = "user_custom_gear"
    static var userThemeReset = "user_theme/reset"
    static var userCoin = "user_coin"
    static var userCoinAll = "user_coin/all"
    static var userLevel = "user_level"
    static var userReset = "user/reset"
    static var userBadge = "user_badge"
    static var purchaseHistory = "purchase_history"
    static var cardFinder = "card_finder"
    static var card = "card/card"
    static var user = "user/me"
    static var configuration = "configuration"
    static var calendarActivity = "calendar_activity_list"
    static var calendarActivityList = "calendar_activity_list/list"
    static var user_custom_activity = "user_custom_activity"
    static var holiday = "holiday"
    static var personMe = "person/me"
    static var person = "user/me"
    static var personImage = "user/me/image"
    static var state = "state"
    static var timeZone = "timezone"
    static var favoriteActivity = "favorite"
    static var theme = "theme"
    static var customGearCategory = "custom_gear_category"
    static var customGearSubCategory = "custom_gear/findList"
    static var user_activity_view = "user_activity_view"
    static var user_activity = "user_activity"
    static var badge = "badge"
    static var level = "level"
    static var authSession = "auth/session"
    static let customPublicRequest = "custom_public_request"
    
    
}
