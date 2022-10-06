//
//  AppDelegate.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 07/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//
/*
@FormUrlEncoded
@POST("driver/rate/user")
suspend fun rateToUser(@Header("lang") language: String,@Header("token") token: String,@Field("order_id") order_id: String,@Field("user_id") restaurant_id: String,@Field("rating") rating: Float,@Field("comments") comments: String): Response<DummyResponse>@FormUrlEncoded
@POST("driver/rate/restaurant")
suspend fun rateToRestaurant(@Header("lang") language: String,@Header("token") token: String,@Field("order_id") order_id: String,@Field("restaurant_id") restaurant_id: String,@Field("rating") rating: Float,@Field("comments") comments: String): Response<DummyResponse>
*/


import UIKit
import Reachability
import IQKeyboardManagerSwift
import GoogleMaps
import UserNotifications
import Firebase
import CoreLocation
import Localize_Swift
import Branch

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let reachability = Reachability()
    var locationManager: CLLocationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(AppConstant.googleKey)
        UIBarButtonItem.appearance().tintColor = AppConstant.appGrayColor
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        self.updateUserCurrentLocation()
        registerForPushNotifications()
        getSavedLanguagePreference()
        fetchDeepLinkData(launchOptions ?? [:])
        return true
    }
    
    
    
    
    func fetchDeepLinkData(_ launchOptions :[UIApplication.LaunchOptionsKey: Any])  {
        let branch: Branch = Branch.getInstance()
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            guard let dict = params as? [String:Any] else {return}
            for value in dict.enumerated(){
                if  value.element.key == "referCode"{
                    let userDefaults = UserDefaults.standard
                    let code  = value.element.value
                    userDefaults.setValue(code, forKey: "referCode")
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "inital")
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.window?.makeKeyAndVisible()
                    
                }
            }
        })
    }
    
    
    private func getSavedLanguagePreference(){
        if let lang = UserDefaults.standard.value(forKey: "savedLang") as? String{
            Localize.setCurrentLanguage(lang)
        }else{
            Localize.setCurrentLanguage("en")
        }
    }
    

    func updateUserCurrentLocation() {
        // Location Manager Start
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        // Location Manager End
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let latestLocation = locations.last! as CLLocation
            print("-----> %.4f",latestLocation.coordinate.latitude)
            print("-----> %.4f",latestLocation.coordinate.longitude)
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(latestLocation.coordinate.latitude, forKey: "current_latitude")
            userDefaults.setValue(latestLocation.coordinate.longitude, forKey: "current_longitude")
//            userDefaults.setValue(23.1014, forKey: "current_latitude")
//            userDefaults.setValue(72.5408, forKey: "current_longitude")
            userDefaults.synchronize()
    }
    
    func setFireBaseDelegate() {
        if let fcmToken = InstanceID.instanceID().token() {
            print("Token : \(fcmToken)");
            CurrentSession.getI().localData.fireBaseToken = fcmToken
        } else {
            print("Error: unable to fetch token");
        }
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    #if User
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    #endif
    
  
    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                granted, error in
                print("Permission granted: \(granted)") // 3
        }
        self.getNotificationSettings()
    }

    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
        }
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Process notification content
        let userInfo = notification.request.content.userInfo as? [String:Any]
        if let type = userInfo?["gcm.notification.type"] as? String{
            if type == "comment"{
                NotificationCenter.default.post(name: .dishCommnets, object: nil, userInfo: userInfo)
            }else{
                NotificationCenter.default.post(name: .newOrders, object: nil, userInfo: userInfo)
            }
        }
        completionHandler([.alert, .sound]) // Display notification Banner
    }
    
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            //OnTap Notification
            let userInfo = response.notification.request.content.userInfo as? [String:Any]
            print(userInfo ?? [:])
         
    //
    //        let storyboard = UIStoryboard(name: "Home", bundle: nil)
    //        let vc = storyboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as? FeedDetailViewController
    //        vc?.isFromPush = true
    //        let rootNC = UINavigationController(rootViewController: vc!)
    //        vc?.noti.isFromNoti = true
    //        vc?.noti.dishID = 18
    //        window?.rootViewController = rootNC
    //        self.window?.makeKeyAndVisible()
    //        //        let TestVC = MainStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! TestVC
    //        //        TestVC.chapterId = dict["chapter_id"] as? String ?? ""
    //        //        TestVC.strSubTitle = dict["chapter"] as? String ?? ""
    //        //        self.navigationC?.isNavigationBarHidden = true
    //        //        self.navigationC?.pushViewController(TestVC, animated: true)
            completionHandler() // Display notification Banner
        }
    
    class func sharedAppDelegate() -> AppDelegate?
    {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        CurrentSession.getI().localData.fireBaseToken = fcmToken
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}
extension Notification.Name {
    public static let dishCommnets = Notification.Name(rawValue: "dishComments")
    public static let newOrders = Notification.Name(rawValue: "newOrders")

}
