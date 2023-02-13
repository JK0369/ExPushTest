//
//  AppDelegate.swift
//  ExPush
//
//  Created by 김종권 on 2023/02/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 1. 푸시 권한 요청
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let doneAction = UNNotificationAction(identifier: "action.done", title: "Done")
        let cancelAction = UNNotificationAction(identifier: "action.cancle", title: "Cancel")
        let categories = UNNotificationCategory(
            identifier: "myNotificationCategory",
            actions: [doneAction, cancelAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        center.setNotificationCategories([categories])
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print(granted)
        }
        
        // 2. device 토큰 획득: application(_:didRegisterForRemoteNotificationsWithDeviceToken:) 메소드 호출
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(tokenString)
    }
    
    // 사일런트 푸시 처리 메소드
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Receive silent push")
        
        completionHandler(.newData)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // foreground에서 시스템 푸시를 수신했을 때 해당 메소드가 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .banner])
    }
    
    // foreground, background에서 시스템 푸시를 탭하거나 dismiss했을때 해당 메소드가 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.actionIdentifier)
    }
}

