//
//  AppDelegate.swift
//  HelloXG
//
//  Created by JOE on 2018/2/8.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window?.rootViewController = UINavigationController.init(rootViewController: ViewController())
        
        startXGPush()
        XGPushSetEnableDebug()
        reportXGPushReceivedInfo(launchOptions: launchOptions)
        
        return true
    }

    //MARK: - XGSDK
    ///打开debug开关
    fileprivate func XGPushSetEnableDebug() {
        XGPush.defaultManager().isEnableDebug = true
        //查看debug开关是否打开
        let debugEnabled = XGPush.defaultManager().isEnableDebug
        print("debug开关是否打开：\(debugEnabled)")
    }
    
    ///启动信鸽推送服务
    fileprivate func startXGPush() {
        XGPush.defaultManager().startXG(withAppID: XGAppID, appKey: XGAppKey, delegate: self)
    }
    
    ///终止信鸽推送服务
    fileprivate func stopXGPush() {
        XGPush.defaultManager().stopXGNotification()
    }
    
    ///统计消息推送的抵达情况
    fileprivate func reportXGPushReceivedInfo(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if let tmpLaunchOptions = launchOptions {
            XGPush.defaultManager().reportXGNotificationInfo(tmpLaunchOptions)
        }
    }
    
    ///统计消息被点击情况
    fileprivate func reportXGPushTapedInfo(userInfo: [AnyHashable : Any]) {
        XGPush.defaultManager().reportXGNotificationInfo(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        reportXGPushTapedInfo(userInfo: userInfo)
    }
    
    //MARK: -
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent.init()
            content.badge = -1
            let request = UNNotificationRequest.init(identifier: "clearBadge", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if let tmpError = error {
                    print("发生错误：\(tmpError)")
                }
            })
        } else {
            // Fallback on earlier versions
            application.applicationIconBadgeNumber = 0
        }
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


}

//MARK: - XGPushDelegate
extension AppDelegate: XGPushDelegate {
    
    @available(iOS 10.0, *)
    func xgPush(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse?, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let tmpUserInfo = response?.notification.request.content.userInfo {
            XGPush.defaultManager().reportXGNotificationInfo(tmpUserInfo)
        }
        
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func xgPush(_ center: UNUserNotificationCenter, willPresent notification: UNNotification?, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let tmpUserInfo = notification?.request.content.userInfo {
            XGPush.defaultManager().reportXGNotificationInfo(tmpUserInfo)
        }
        
        completionHandler([.alert, .badge, .sound])
    }
    
    ///监控信鸽推送服务地启动情况
    func xgPushDidFinishStart(_ isSuccess: Bool, error: Error?) {
        print("信鸽推送服务的启动情况：\(isSuccess)")
        if isSuccess == false {
            print("错误：\(error)")
        }
    }
    
    ///监控信鸽服务的终止情况
    func xgPushDidFinishStop(_ isSuccess: Bool, error: Error?) {
        print("信鸽服务的终止情况：\(isSuccess)")
        if isSuccess == false {
            print("错误：\(error)")
        }
    }
    
    ///监控信鸽服务上报推送消息的情况
    func xgPushDidReportNotification(_ isSuccess: Bool, error: Error?) {
        print("监控信鸽服务上报推送消息的情况：\(isSuccess)")
        if isSuccess == false {
            print("错误：\(error)")
        }
    }
}

















