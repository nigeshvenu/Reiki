//
//  VCExtensionHelper.swift
//  iAautoauction
//
//  Created by NewAgeSMB on 08/01/21.
//  Copyright © 2021 NewAgeSMB. All rights reserved.
//

import UIKit

extension UIViewController{
    
    
    
    func getAnimationPreviewVC()->AnimationPreviewVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "AnimationPreviewVC") as! AnimationPreviewVC
        return VC
    }
    
    func getManageNotificationVC()->ManageNotificationVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "ManageNotificationVC") as! ManageNotificationVC
        return VC
    }
    
    func getCardHistoryVC()->CardHistoryVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "CardHistoryVC") as! CardHistoryVC
        return VC
    }
    
    func getLevelUPPopUpVC()->LevelUPPopUpVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "LevelUPPopUpVC") as! LevelUPPopUpVC
        return VC
    }
    
    func getPurchaseHistoryVC()->PurchaseHistoryVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "PurchaseHistoryVC") as! PurchaseHistoryVC
        return VC
    }
    
    func getBadgeVC()->BadgesVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "BadgesVC") as! BadgesVC
        return VC
    }
    
    func getLevelVC()->LevelVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "LevelVC") as! LevelVC
        return VC
    }
    
    func getGoldCoinVC()->GoldCoinVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "GoldCoinVC") as! GoldCoinVC
        return VC
    }
    
    func getCardFinderVC()->CardFinderVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "CardFinderVC") as! CardFinderVC
        return VC
    }
    
    func getThemeVC()->ThemeVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "ThemeVC") as! ThemeVC
        return VC
    }
    
    func getFavoritesVC()->FavoritesVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "FavoritesVC") as! FavoritesVC
        return VC
    }
    
    func getUnlockHiddenChestVC()->UnlockHiddenChestVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "UnlockHiddenChestVC") as! UnlockHiddenChestVC
        return VC
    }
    
    func getUnlockablesVC()->UnlockablesVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "UnlockablesVC") as! UnlockablesVC
        return VC
    }
    
    func getEventCompletVC()->EventCompletVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "EventCompletVC") as! EventCompletVC
        return VC
    }
    
    func getDatePickerVC()->DatePickerVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "DatePickerVC") as! DatePickerVC
        return VC
    }
    
    func getCreateCustomEventVC()->CreateCustomEventVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "CreateCustomEventVC") as! CreateCustomEventVC
        return VC
    }
    
    func getAddJournalVC()->AddJournalVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "AddJournalVC") as! AddJournalVC
        return VC
    }
    
    func getEventDetailVC()->EventDetailVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "EventDetailVC") as! EventDetailVC
        return VC
    }
    
    func getAllEventsVC()->AllEventsVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "AllEventsVC") as! AllEventsVC
        return VC
    }
    
    func getCalendarVC()->CalendarVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "CalendarVC") as! CalendarVC
        return VC
    }
    
    func getHomePageVC()->HomePageVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "HomePageVC") as! HomePageVC
        return VC
    }
    
    func getViewControllerVC()->ViewController{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "ViewController") as! ViewController
        return VC
    }
    
    func getSignupOtpVC()->SignupOtpVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "SignupOtpVC") as! SignupOtpVC
        return VC
    }
    
    func getSignupSetPasswordVC()->SignupSetPasswordVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "SignupSetPasswordVC") as! SignupSetPasswordVC
        return VC
    }
    
    func getSignupAboutMeVC()->SignupAboutMeVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "SignupAboutMeVC") as! SignupAboutMeVC
        return VC
    }
    
    func getSignupCharacterVC()->SignupCharacterVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "SignupCharacterVC") as! SignupCharacterVC
        return VC
    }
    
    func getSignupSuccessVC()->SignupSuccessVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "SignupSuccessVC") as! SignupSuccessVC
        return VC
    }
    
    func getLoginPageVC()->LoginPageVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "LoginPageVC") as! LoginPageVC
        return VC
    }
    
    func getForgotPasswordVC()->ForgotPasswordVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "ForgotPasswordVC") as! ForgotPasswordVC
        return VC
    }
    
    func getProfileVC()->ProfileVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "ProfileVC") as! ProfileVC
        return VC
    }
    
    func getEditProfileVC()->EditProfileVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "EditProfileVC") as! EditProfileVC
        return VC
    }
    
    func getChangePasswordVC()->ChangePasswordVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "ChangePasswordVC") as! ChangePasswordVC
        return VC
    }
    
    func getChangeMobileNumberVC()->ChangeMobileNumberVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "ChangeMobileNumberVC") as! ChangeMobileNumberVC
        return VC
    }
    
    func getOtpVC()->OtpVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "OtpVC") as! OtpVC
        return VC
    }
    
    func getForgotPasswordSetPwdVC()->ForgotPasswordSetPwdVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "ForgotPasswordSetPwdVC") as! ForgotPasswordSetPwdVC
        return VC
    }
    
    func getWebViewVC()->WebViewVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "WebViewVC") as! WebViewVC
        return VC
    }
    
    func getPopUpVC()->PopUpVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "PopUpVC") as! PopUpVC
        return VC
    }
    
    func getSideMenuVC()->SideMenuVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "SideMenuVC") as! SideMenuVC
        return VC
    }
    
    func getBadgeCriteriaVC()->BadgeCriteriaVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "BadgeCriteriaVC") as! BadgeCriteriaVC
        return VC
    }
    
    func getLevelCriteriaVC()->LevelCriteriaVC{
        let VC = instantiateWithIdentifier(storyboard: "Main",identifier: "LevelCriteriaVC") as! LevelCriteriaVC
        return VC
    }
    
    func instantiateWithIdentifier(storyboard:String,identifier:String)->UIViewController{
        
        if #available(iOS 13.0, *) {
            return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(identifier: identifier)
        } else {
            // Fallback on earlier versions
            return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        }
    }
}
