//
//  AppDelegate.swift
//  Reiki
//
//  Created by NewAgeSMB on 18/08/22.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase

var newNotification : NSDictionary? = nil

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var progressVC : ActivityVC?
    var orientation: UIInterfaceOrientationMask = .portrait
    static let shared = UIApplication.shared.delegate as! AppDelegate
    var FCMToken:String?
    var notificationArray = [NotificationModal]()
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationPopUp), name: Notification.Name("Notification"), object: nil)
        IQKeyboardManager.shared.enable = true
        registerPushNotification(application: application)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if ((launchOptions) != nil) { //launchOptions is not nil
            if let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as! [NSObject : AnyObject]? {
                newNotification = remoteNotification as NSDictionary
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }

    func registerPushNotification(application:UIApplication){
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {(granted, error) in
                if granted{
                    UNUserNotificationCenter.current().delegate = self
                }
            })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    func showLoading(isShow: Bool) {
        if isShow {
            // Remove progress view if already exist
            if progressVC != nil {
                progressVC?.view.removeFromSuperview()
                progressVC = nil
            }
            progressVC = ActivityVC.viewController()
            if let rootVC = UIWindow.key {
                rootVC.addSubview((progressVC?.view)!)
            }
        } else {
            if progressVC != nil {
                progressVC?.view.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Reiki")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate  : MessagingDelegate ,UNUserNotificationCenterDelegate {
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        print("Device Token : \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register : \(error.localizedDescription)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        FCMToken = fcmToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        if newNotification == nil{
            let userInfo = response.notification.request.content.userInfo
                if userInfo.count > 0 {
                   if let userInfoDict = userInfo as? [String:Any]{
                        if let type = userInfoDict["type"] as? String{
                            if type == "public"{
                                if let event = self.getObject(userInfo: userInfo){
                                    let modal = EventModal()
                                    modal.createModal(dict: event)
                                    modal.eventType = .publicType
                                    self.getEventDetail(event: modal)
                                }
                            }else{
                                if let event = self.getObject(userInfo: userInfo){
                                   let modal = EventModal()
                                    modal.createModal(dict: event)
                                    modal.eventType = .custom
                                    self.getEventDetail(event: modal)
                                }
                           }
                      }
                  }
             }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
        print(userInfo)
        if let type = userInfo["type"] as? String{
            if type == "level"{
                let level = (userInfo["level_number"] as? String) ?? ""
                let prestige = (userInfo["prestige"] as? String) ?? ""
                let modal = NotificationModal()
                modal.type = type
                modal.levelNo = level
                modal.isprestige = prestige == "true" ? true : false
                notificationArray.append(modal)
            }else if type == "badge"{
                if let badge = getArray(userInfo: userInfo){
                    for i in badge{
                        let modal = NotificationModal()
                        modal.type = type
                        modal.bageNo = anyToStringConverter(dict: i, key: "name")
                        notificationArray.append(modal)
                    }
                }
            }
            self.notificationPopUp()
        }
        print("Notification background")
    }
    
    func getArray(userInfo:[AnyHashable: Any])->[[String:Any]]?{
        do {
          let dd =  userInfo["badge"] as! String
          let con = try JSONSerialization.jsonObject(with: dd.data(using: .utf8)!, options: []) as! [[String:Any]]
          return con
        }catch {
           print(error)
            return nil
        }
    }
    
    func getObject(userInfo:[AnyHashable: Any])->[String:Any]?{
        do {
          let dd =  userInfo["event"] as! String
          let con = try JSONSerialization.jsonObject(with: dd.data(using: .utf8)!, options: []) as! [String:Any]
          return con
        }catch {
           print(error)
            return nil
        }
    }
    
    func getlevelPopup(level:String,prestige:Bool){
      if let rootViewController = self.window!.rootViewController as? UINavigationController {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "LevelUPPopUpVC") as? LevelUPPopUpVC {
             viewcontroller.modalPresentationStyle = .overFullScreen
             viewcontroller.level = level
             viewcontroller.isprestige = prestige
             rootViewController.present(viewcontroller, animated: false)
          }
       }
    }
    
    func getBadgePopup(badge:String){
      if let rootViewController = self.window!.rootViewController as? UINavigationController {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewBadgePopUpVC") as? NewBadgePopUpVC {
             viewcontroller.modalPresentationStyle = .overFullScreen
             viewcontroller.badge = badge
             rootViewController.present(viewcontroller, animated: false)
          }
       }
    }
    
    func getEventDetail(event:EventModal){
      if let rootViewController = self.window!.rootViewController as? UINavigationController {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "EventDetailVC") as? EventDetailVC {
             viewcontroller.event = event
             rootViewController.pushViewController(viewcontroller, animated: true)
          }
       }
    }
}

extension AppDelegate{
    
    @objc func notificationPopUp(){
        if notificationArray.count > 0{
            if let topController = self.window?.rootViewController {
                if topController.presentedViewController == nil{
                    for i in notificationArray{
                        if i.type == "level"{
                            self.getlevelPopup(level: i.levelNo, prestige: i.isprestige)
                            self.notificationArray.remove(at: 0)
                            return
                        }else if i.type == "badge"{
                            self.getBadgePopup(badge: i.bageNo)
                            self.notificationArray.remove(at: 0)
                            return
                        }
                    }
                }
            }
        }
    }
}
