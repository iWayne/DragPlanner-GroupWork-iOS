//
//  AppDelegate.swift
//  ChronList
//
//  Created by Shan Shawn on 4/17/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //Notification Center
        //----------------------------------------------------------------------
        var laterAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        laterAction.identifier = "FIRST_ACTION"
        laterAction.title = "First Action"
        
        
        laterAction.activationMode = UIUserNotificationActivationMode.Background
        laterAction.destructive = true
        laterAction.authenticationRequired = false
        
        var finishAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        finishAction.identifier = "SECOND_ACTION"
        finishAction.title = "Second Action"
        
        finishAction.activationMode = UIUserNotificationActivationMode.Foreground
        finishAction.destructive = false
        finishAction.authenticationRequired = false
        
        var thirdAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        thirdAction.identifier = "THIRD_ACTION"
        thirdAction.title = "Third Action"
        
        thirdAction.activationMode = UIUserNotificationActivationMode.Background
        thirdAction.destructive = true
        thirdAction.authenticationRequired = false
        
        //category
        var firstCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "FIRST_CATEGORY"
        
        let defaultActions: NSArray = [laterAction, finishAction, thirdAction]
        let minimalActions: NSArray = [laterAction, finishAction]
        
        firstCategory.setActions(defaultActions, forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        
        let categories: NSSet = NSSet(object: firstCategory)
        
        let types: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge
        let mySettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
        //----------------------------------------------------------------------
        return true
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if(identifier == "SECOND_ACTION"){
            println("first action")
        }
        completionHandler()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println(notification.userInfo!["key"]!)
        showActoin()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

