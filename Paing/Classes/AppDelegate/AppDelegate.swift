//
//  AppDelegate.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 20/05/21.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import FirebaseInstanceID
import UserNotifications

let ObjAppdelegate = UIApplication.shared.delegate as! AppDelegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navController: UINavigationController?
    
    
    
    private static var AppDelegateManager: AppDelegate = {
        let manager = UIApplication.shared.delegate as! AppDelegate
        return manager
    }()
    // MARK: - Accessors
    class func AppDelegateObject() -> AppDelegate {
        return AppDelegateManager
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        UserDefaults.standard.setValue(deviceID, forKey: UserDefaults.Keys.strVenderId)
         print(deviceID)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        FirebaseApp.configure()
        self.registerForRemoteNotification()
        Messaging.messaging().delegate = self
        
        (UIApplication.shared.delegate as? AppDelegate)?.self.window = window
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "412429099515-vso8v6e2rd8cu63hlohisc8dbc22gafm.apps.googleusercontent.com"
        
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        self.settingRootController()
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
//        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
}


//Manage AutoLogin
extension AppDelegate {
    
    func LoginNavigation(){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        navController = sb.instantiateViewController(withIdentifier: "LoginNav") as? UINavigationController
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func HomeNavigation() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "Reveal")
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func settingRootController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        //        let navController = UINavigationController(rootViewController: setViewController)
        appDelegate.window?.rootViewController = vc
    }
    
}

//MARK:- notification setup
extension AppDelegate:UNUserNotificationCenterDelegate{
    
    func registerForRemoteNotification() {
        // iOS 10 support
        if #available(iOS 10, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options:authOptions){ (granted, error) in
                UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
                Messaging.messaging().delegate = self
                let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [], intentIdentifiers: [], options: [])
                let center = UNUserNotificationCenter.current()
                center.setNotificationCategories(Set([deafultCategory]))
            }
        }else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector:
            #selector(tokenRefreshNotification), name:
            .InstanceIDTokenRefresh, object: nil)
    }
}

//MARK: - FireBase Methods / FCM Token
extension AppDelegate : MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        objAppShareData.strFirebaseToken = fcmToken ?? ""
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        objAppShareData.strFirebaseToken = fcmToken
        ConnectToFCM()
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let result = result {
                print("Remote instance ID token: \(result.token)")
               // objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(result.token)")
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        ConnectToFCM()
    }
    
    func ConnectToFCM() {
        InstanceID.instanceID().instanceID { (result, error) in
            
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let result = result {
                print("Remote instance ID token: \(result.token)")
             //   objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(result.token)")
            }
        }
    }
    

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let userInfo = notification.request.content.userInfo as? [String : Any]{
            print(userInfo)

            //Update BadgeCount
            if let badgeCount = UserDefaults.standard.value(forKey: "badge")as? Int{
                let newCount  = badgeCount + 1
                UserDefaults.standard.setValue(newCount, forKey: "badge")
            }else{
                UserDefaults.standard.setValue(1, forKey: "badge")
            }
            
            
         //   objAppShareData.notificationDict = userInfo
//            self.navWithNotification(type: notificationType, bookingID: bookingID)
        }
        completionHandler([.alert,.sound,.badge])
    }
    
    
    
    func navWithNotification(type:String,bookingID:String){

    }

    //TODO: called When you tap on the notification in background
   @available(iOS 10.0, *)
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
       print(response)
       switch response.actionIdentifier {
       case UNNotificationDismissActionIdentifier:
           print("Dismiss Action")
       case UNNotificationDefaultActionIdentifier:
           print("Open Action")
           if let userInfo = response.notification.request.content.userInfo as? [String : Any]{
               print(userInfo)
               self.handleNotificationWithNotificationData(dict: userInfo)
           }
       case "Snooze":
           print("Snooze")
       case "Delete":
           print("Delete")
       default:
           print("default")
       }
       completionHandler()
   }
    
    func handleNotificationWithNotificationData(dict:[String:Any]){
        print(dict)
        let userID = dict["gcm.notification.user_request_id"]as? String ?? ""
        print(userID)
      //  objAppShareData.isFromNotification = true
       // objAppShareData.userReqID = dict["gcm.notification.user_request_id"] as? String ?? "0"
    //    self.HomeNavigation()
        
//        var strType = ""
//        var bookingID = ""
//        if let notiType = dict["notification_type"] as? String{
//            strType = notiType
//        }
//        if let type = dict["type"] as? Int{
//            strType = String(type)
//        }else if let type = dict["type"] as? String{
//            strType = type
//        }
//
//        if let id = dict["reference_id"] as? Int{
//            bookingID = String(id)
//        }else if let id = dict["reference_id"] as? String{
//            bookingID = id
//        }
//        objAppShareData.notificationDict = dict
//        objAppShareData.isFromNotification = true
//        objAppShareData.notificationType = strType
//        self.homeNavigation(animated: false)
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}


public extension UIWindow {
    
    var visibleViewController: UIViewController? {
        
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
        
    }
    
    static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        
        if let nc = vc as? UINavigationController {
            
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
            
        } else if let tc = vc as? UITabBarController {
            
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
            
        } else {
            
            if let pvc = vc?.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
                
            } else {
                
                return vc
                
            }
            
        }
        
    }
    
}
