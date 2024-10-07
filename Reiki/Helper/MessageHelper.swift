//
//  MessageHelper.swift
//  prospect
//
//  Created by NewAgeSMB on 11/05/19.
//  Copyright © 2019 NewAgeSMB. All rights reserved.
//

import UIKit

class MessageHelper: NSObject {

    struct ErrorMessage{
        
        //Login
        
        //Profile
        static var imageEmpty = "Please choose a profile image"
        static var firstNameEmpty = "Please enter first name"
        static var lastNameEmpty = "Please enter last name"
        static var enterPhoneNumber = "Please enter Mobile number"
        static var invalidPhoneNumber = "Please enter a valid Mobile number"
        static var cityEmpty = "Please enter city"
        static var stateEmpty = "Please enter state"
        static var zipEmpty = "Please enter zip"
        static var zipeCodeInvalid = "Please enter a  valid zip code"
        static var timeZoneEmpty = "Please choose time zone"
        static var emailEmptyAlert = "Enter email address"
        static var emailInvalidAlert = "Enter a valid mail"
        static var passwordEmptyAlert = "Please enter password"
        static var newPassword = "Please enter new password"
        static var currentPassword = "Please enter current password"
        static var currentPasswordLengthAlert = "Alert! current password should contain atleast 8 letters"
        static var currentPasswordWrong = "Check your current password"
        static var newPasswordLengthAlert = "Alert! new password should contain atleast 8 letters"
        static var aboutMeEmpty = "Please add something about yourself"
        static var otpEmpty = "Please enter Verification code"
        static var passwordLengthAlert = "Alert! password should contain atleast 8 letters"
        static var confirmPasswordEmptyAlert = "Please enter confirm password"
        static var confirmPasswordMismatch = "Oops! Password doesn't match"
        static var agreementNotAccepted = "Please accept terms & conditions and privacy policy"
        
        //Custom event
        static var eventTitleEmpty = "Please enter event title"
        static var dateEmpty = "Please choose event date"
        static var eventDescEmpty = "Please enter event description"
        static var eventImageEmpty = "Please choose an event image"
        
        //joural
        static var journalEmpty = "Please add something"
        
        //Edit profile
        static var noChanges = "Alert! There is nothing to update"
        
        static var purchaseElementsEmpty = "No items"
        
        //Forgot Password
     
       //Status code 401 : 403
        static var userSessionExpired = "User session expired! Please login again or contact admin."
        
        //Internet offline
        static var internetOffline = "The Internet connection appears to be offline."
        static var somethingWrong = "Something went wrong"
        
        static var animationEmpty = "No preview available"
        
    }
    
    struct SuccessMessage {
        static var otpSent = "Verification code sent"
        static var otpResend = "Verification code has been resend successfully"
        static var codeVerified = "Verification code has been verified successfully"
        static var aboutMeAdded = "Description added successfully"
        static var passwordAdded = "Password added successfully"
        static var loginSuccess = "You have successfully logged in"
        static var logoutSuccess = "You have successfully logged out"
        static var profileUpdated = "Profile updated successfully"
        static var profileCreated = "Profile created successfully"
        static var mobileUpdated = "Mobile number updated successfully"
        static var passwordChanged = "Password changed successfully"
        static var accountDeleted = "Account deleted successfully"
        static var favorited = "Event added to favorites"
        static var removedFavorite = "Event removed from favorites"
        static var customEventCreated = "Event created successfully"
        static var customEventEdited = "Event edited successfully"
        static var customEventDeleted = "Event deleted successfully"
        static var eventCompleted = "Event completed successfully"
        static var journalUpdate = "Journal updated successfully"
        static var journalAdded = "Journal added successfully"
        static var themeUnlocked = "Theme unlocked successfully"
        static var themeApplied = "Theme applied successfully"
        static var themeRemove = "Theme removed successfully"
        static var gearApplied = "applied successfully"
        static var gearRemove = "removed successfully"
        static var themeReset = "Theme reset successfully"
        static var unlocked = "unlocked successfully"
        static var resetLevel = "Reset successfully"
        static var customNotEnabled = "Custom notification enabled"
        static var customNotDisabled = "Custom notification disabled"
        static var publicNotEnabled = "Admin notification enabled"
        static var publicNotDisabled = "Admin notification disabled"
        static var eventSubmittedForAdminReview = "Your event has been successfully submitted for admin review!"
    }
    
    struct PopupMessage {
        static var LogoutMessage = "Are you sure you want to logout?"
        static var deleteAccountMessage = "Your profile and all the related information will be deleted from our App"
        static var deleteEventMessage = "Are you sure you want to delete this event?"
        static var saveProfileMessage = "You have made changes. Do you want to save them?"
        static var unlockThemeMessage = "Are you sure you want to unlock this theme?"
        static var applyThemeMessage = "Are you sure you want to apply this theme?"
        static var removeThemeMessage = "Are you sure you want to remove this theme?"
        static var unlockMessage = "Are you sure you want to unlock this"
        static var applyMessage = "Are you sure you want to apply this"
        static var removeMessage = "Are you sure you want to remove this"
        static var resetLevelMessage = "Are you sure you want to reset? This will completely reset all levels and you will start from level 1."
        static var submitToAdmin = "Are you sure you want to submit this event to admin?"
      
    }
    
}
