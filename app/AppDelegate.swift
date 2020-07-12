//
//  AppDelegate.swift
//
//  Created by Demyanchuk Dmitry on 28.01.18.
//  Copyright © 2018 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

import FacebookCore
import FacebookLogin
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if #available(iOS 10.0, *) {
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,selector: #selector(self.tokenRefreshNotification),
                                               name: NSNotification.Name.firInstanceIDTokenRefresh,
                                               object: nil)
        
        
        if #available(iOS 10.0, *) {
            
            if let info = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable:Any] {
                
                print("Background Message 1 ID: \(info["gcm.message_id"]!)")
            }
        }
    
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        connectToFcm()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        
        print(userInfo)
        
        handleNorification(userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func handleNorification(userInfo:[AnyHashable:Any]){
        
        if let remoteMessage = userInfo as? [String:Any]{
        
        if let type = remoteMessage["type"] as? NSString {
            
            print(type)
            
            let mType = Int((type) as String)!
            
            let accountId = remoteMessage["accountId"] as? NSString
            
            let mAccountId = Int((accountId)! as String)!
            
            switch mType {
                
            case Constants.GCM_NOTIFY_FOLLOWER:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowFollowersGCM() == 1) {
                        
                        createNotify(id: "follower", title: NSLocalizedString("label_new_follower_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_follower", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_MESSAGE:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    let mChatId = Int((remoteMessage["id"] as? NSString)! as String)!
                    
                    if (iApp.sharedInstance.getCurrentChatId() != mChatId) {
                        
                        if (iApp.sharedInstance.getMessagesCount() == 0) {
                            
                            iApp.sharedInstance.setMessagesCount(messagesCount: iApp.sharedInstance.getMessagesCount() + 1)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        }
                        
                        if (iApp.sharedInstance.getAllowMessagesGCM() == 1) {
                            
                            createNotify(id: "message", title: NSLocalizedString("label_new_message_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_message", comment: ""))
                        }
                    }
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                        
                        iApp.sharedInstance.msg.setId(id: Int((remoteMessage["msgId"] as? NSString)! as String)!)
                        iApp.sharedInstance.msg.setFromUserId(fromUserId: Int((remoteMessage["msgFromUserId"] as? NSString)! as String)!)
                        iApp.sharedInstance.msg.setText(text:  (remoteMessage["msgMessage"] as? NSString)! as String)
                        iApp.sharedInstance.msg.setPhotoUrl(photoUrl: (remoteMessage["msgFromUserPhotoUrl"] as? NSString)! as String)
                        iApp.sharedInstance.msg.setFullname(fullname: (remoteMessage["msgFromUserFullname"] as? NSString)! as String)
                        iApp.sharedInstance.msg.setUsername(username: (remoteMessage["msgFromUserUsername"] as? NSString)! as String)
                        iApp.sharedInstance.msg.setImgUrl(imgUrl: (remoteMessage["msgImgUrl"] as? NSString)! as String)
                        iApp.sharedInstance.msg.setTimeAgo(timeAgo: (remoteMessage["msgTimeAgo"] as? NSString)! as String)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChat"), object: nil)
                    }
                    
                }
                
                break
                
            case Constants.GCM_NOTIFY_SEEN:
                
                let mChatId = Int((remoteMessage["id"] as? NSString)! as String)!
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "seenChat"), object: nil)
                }
                
                break
                
            case Constants.GCM_NOTIFY_TYPING_START:
                
                let mChatId = Int((remoteMessage["id"] as? NSString)! as String)!
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "typingStartChat"), object: nil)
                }
                
                break
                
            case Constants.GCM_NOTIFY_TYPING_END:
                
                let mChatId = Int((remoteMessage["id"] as? NSString)! as String)!
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "typingEndChat"), object: nil)
                }
                
                break
                
            case Constants.GCM_NOTIFY_LIKE:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowLikesGCM() == 1) {
                        
                        createNotify(id: "like", title: NSLocalizedString("label_new_like_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_like", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_COMMENT:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowCommentsGCM() == 1) {
                        
                        createNotify(id: "comment", title: NSLocalizedString("label_new_comment_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_COMMENT_REPLY:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowCommentsReplyGCM() == 1) {
                        
                        createNotify(id: "comment_reply", title: NSLocalizedString("label_new_comment_reply_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment_reply", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_GIFT:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowGiftsGCM() == 1) {
                        
                        createNotify(id: "gift", title: NSLocalizedString("label_new_gift_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_gift", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_IMAGE_LIKE:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowLikesGCM() == 1) {
                        
                        createNotify(id: "like", title: NSLocalizedString("label_new_like_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_like", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_IMAGE_COMMENT:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowCommentsGCM() == 1) {
                        
                        createNotify(id: "comment", title: NSLocalizedString("label_new_comment_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_IMAGE_COMMENT_REPLY:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowCommentsReplyGCM() == 1) {
                        
                        createNotify(id: "comment_reply", title: NSLocalizedString("label_new_comment_reply_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment_reply", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_SYSTEM:
                
                let app_title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                
                let fcm_message = remoteMessage["msg"] as? NSString
                
                createNotify(id: "system", title: app_title, subtitle: "", body: fcm_message! as String)
                
                break
                
            case Constants.GCM_NOTIFY_CUSTOM:
                
                if (iApp.sharedInstance.getId() != 0) {
                    
                    let app_title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                    
                    let fcm_message = remoteMessage["msg"] as? NSString
                    
                    createNotify(id: "custom", title: app_title, subtitle: "", body: fcm_message! as String)
                }
                
                break
                
            case Constants.GCM_NOTIFY_PERSONAL:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    let app_title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                    
                    let fcm_message = remoteMessage["msg"] as? NSString
                    
                    createNotify(id: "personal", title: app_title, subtitle: "", body: fcm_message! as String)
                }
                
                break
                
            default:
                
                break
            }
            
        }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification) {
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            
//            print("FCM_ID token: \(refreshedToken)")
            
            iApp.sharedInstance.setFcmRegId(ios_fcm_regid: refreshedToken)
        }
        
        print("tokenRefreshNotification")
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        
        FIRMessaging.messaging().connect { (error) in
            
            if error != nil {
                
                print("Unable to connect with FCM | App Delegate.")
                
            } else {
                
                print("Connected to FCM | App Delegate.")
                
                if let refreshedToken = FIRInstanceID.instanceID().token() {
                    
                    iApp.sharedInstance.setFcmRegId(ios_fcm_regid: refreshedToken)
                }
            }
        }
    }
    
}

// [END ios_10_message_handling]



extension AppDelegate:UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == "follower" {
            
            completionHandler( [.alert,.sound,.badge])
            
        } else if (notification.request.identifier == "message") {
            
            completionHandler( [.alert,.sound,.badge])
            
        } else if (notification.request.identifier == "like") {
            
            completionHandler( [.alert,.sound,.badge])
            
        } else if (notification.request.identifier == "comment") {
            
            completionHandler( [.alert,.sound,.badge])
            
        } else if (notification.request.identifier == "comment_reply") {
            
            completionHandler( [.alert,.sound,.badge])
            
        } else if (notification.request.identifier == "gift") {
            
            completionHandler( [.alert,.sound,.badge])
            
        } else if (notification.request.identifier == "system") {
            
            completionHandler( [.alert,.sound,.badge])
            
        } else if (notification.request.identifier == "custom") {
            
            completionHandler( [.alert,.sound,.badge])
            
        } else if (notification.request.identifier == "personal") {
            
            completionHandler( [.alert,.sound,.badge])
        }
    }
}

// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    
    func createNotify(id: String, title: String, subtitle: String, body: String) {
        
        print("notification will be triggered in five seconds..Hold on tight")
        
        let content = UNMutableNotificationContent()
        content.title = title
        
        if (subtitle.count > 0) {
            
            content.subtitle = subtitle
        }
        
        if (body.count > 0) {
            
            content.body = body
        }
        
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error!.localizedDescription)
            }
        }
    }
    
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        
        print(remoteMessage)
        
        print("foreground!!!!!!!!!!!!!!!!!!!!")
        
        if let type = remoteMessage.appData["type"] as? NSString {
            
            print(type)
            
            let mType = Int((type) as String)!
            
            let accountId = remoteMessage.appData["accountId"] as? NSString
            
            let mAccountId = Int((accountId)! as String)!
            
            switch mType {
                
            case Constants.GCM_NOTIFY_FOLLOWER:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowFollowersGCM() == 1) {
                        
                        createNotify(id: "follower", title: NSLocalizedString("label_new_follower_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_follower", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_MESSAGE:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    let mChatId = Int((remoteMessage.appData["id"] as? NSString)! as String)!
                    
                    if (iApp.sharedInstance.getCurrentChatId() != mChatId) {
                        
                        if (iApp.sharedInstance.getMessagesCount() == 0) {
                            
                            iApp.sharedInstance.setMessagesCount(messagesCount: iApp.sharedInstance.getMessagesCount() + 1)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        }
                        
                        if (iApp.sharedInstance.getAllowMessagesGCM() == 1) {
                            
                            createNotify(id: "message", title: NSLocalizedString("label_new_message_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_message", comment: ""))
                        }
                    }
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                        
                        iApp.sharedInstance.msg.setId(id: Int((remoteMessage.appData["msgId"] as? NSString)! as String)!)
                        iApp.sharedInstance.msg.setFromUserId(fromUserId: Int((remoteMessage.appData["msgFromUserId"] as? NSString)! as String)!)
                        iApp.sharedInstance.msg.setText(text:  (remoteMessage.appData["msgMessage"] as? NSString)! as String)
                        iApp.sharedInstance.msg.setPhotoUrl(photoUrl: (remoteMessage.appData["msgFromUserPhotoUrl"] as? NSString)! as String)
                        iApp.sharedInstance.msg.setFullname(fullname: (remoteMessage.appData["msgFromUserFullname"] as? NSString)! as String)
                        iApp.sharedInstance.msg.setUsername(username: (remoteMessage.appData["msgFromUserUsername"] as? NSString)! as String)
                        iApp.sharedInstance.msg.setImgUrl(imgUrl: (remoteMessage.appData["msgImgUrl"] as? NSString)! as String)
                        iApp.sharedInstance.msg.setTimeAgo(timeAgo: (remoteMessage.appData["msgTimeAgo"] as? NSString)! as String)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChat"), object: nil)
                    }
                    
                }
                
                break
                
            case Constants.GCM_NOTIFY_SEEN:
                
                let mChatId = Int((remoteMessage.appData["id"] as? NSString)! as String)!
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "seenChat"), object: nil)
                }
                
                break
                
            case Constants.GCM_NOTIFY_TYPING_START:
                
                let mChatId = Int((remoteMessage.appData["id"] as? NSString)! as String)!
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "typingStartChat"), object: nil)
                }
                
                break
                
            case Constants.GCM_NOTIFY_TYPING_END:
                
                let mChatId = Int((remoteMessage.appData["id"] as? NSString)! as String)!
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "typingEndChat"), object: nil)
                }
                
                break
                
            case Constants.GCM_NOTIFY_LIKE:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowLikesGCM() == 1) {
                        
                        createNotify(id: "like", title: NSLocalizedString("label_new_like_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_like", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_COMMENT:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowCommentsGCM() == 1) {
                        
                        createNotify(id: "comment", title: NSLocalizedString("label_new_comment_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_COMMENT_REPLY:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowCommentsReplyGCM() == 1) {
                        
                        createNotify(id: "comment_reply", title: NSLocalizedString("label_new_comment_reply_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment_reply", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_GIFT:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowGiftsGCM() == 1) {
                        
                        createNotify(id: "gift", title: NSLocalizedString("label_new_gift_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_gift", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_IMAGE_LIKE:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowLikesGCM() == 1) {
                        
                        createNotify(id: "like", title: NSLocalizedString("label_new_like_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_like", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_IMAGE_COMMENT:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowCommentsGCM() == 1) {
                        
                        createNotify(id: "comment", title: NSLocalizedString("label_new_comment_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_IMAGE_COMMENT_REPLY:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                    
                    if (iApp.sharedInstance.getAllowCommentsReplyGCM() == 1) {
                        
                        createNotify(id: "comment_reply", title: NSLocalizedString("label_new_comment_reply_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment_reply", comment: ""))
                    }
                }
                
                break
                
            case Constants.GCM_NOTIFY_SYSTEM:
                
                let app_title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                
                let fcm_message = remoteMessage.appData["msg"] as? NSString
                
                createNotify(id: "system", title: app_title, subtitle: "", body: fcm_message! as String)
                
                break
                
            case Constants.GCM_NOTIFY_CUSTOM:
                
                if (iApp.sharedInstance.getId() != 0) {
                    
                    let app_title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                    
                    let fcm_message = remoteMessage.appData["msg"] as? NSString
                    
                    createNotify(id: "custom", title: app_title, subtitle: "", body: fcm_message! as String)
                }
                
                break
                
            case Constants.GCM_NOTIFY_PERSONAL:
                
                if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                    
                    let app_title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                    
                    let fcm_message = remoteMessage.appData["msg"] as? NSString
                    
                    createNotify(id: "personal", title: app_title, subtitle: "", body: fcm_message! as String)
                }
                
                break
                
            default:
                
                break
            }
            
        }
        
    }
}
