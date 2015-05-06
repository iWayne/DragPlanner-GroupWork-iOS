//
//  AppDelegate.swift
//  CalendarSw
//
//  Created by Shan Shawn on 4/6/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("9Sit7m2o6BZNIYV53uN3sj2HYMMguJxJqo5JyYpb",
            clientKey: "1G5DWri9FrSljKPLKy0hJUxPaMpnc6Fhav14Gvdo")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //Notification Center
        //----------------------------------------------------------------------
        var laterAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        laterAction.identifier = "LATER_ACTION"
        laterAction.title = "Later"
        
        laterAction.activationMode = UIUserNotificationActivationMode.Background
        laterAction.destructive = false
        laterAction.authenticationRequired = false
        
        var finishAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        finishAction.identifier = "DO_ACTION"
        finishAction.title = "Do Now"
        
        finishAction.activationMode = UIUserNotificationActivationMode.Foreground
        finishAction.destructive = false
        finishAction.authenticationRequired = false
        
        //category
        var firstCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "FIRST_CATEGORY"
        
        let minimalActions: NSArray = [laterAction, finishAction]
        
        firstCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        
        let categories: NSSet = NSSet(object: firstCategory)
        
        let types: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        let mySettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
        //----------------------------------------------------------------------
        
        
        return true
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        if(identifier == "DO_ACTION"){
            //Change Background Color   eventID = notification.userinfo["key"] as String
            println("change BK")
            var eventID:String = notification.userInfo!["key"]! as String
            var query = PFQuery(className: "event")
            query.getObjectInBackgroundWithId(eventID) {
                (newObj: PFObject?, error: NSError?) -> Void in
                if error != nil && newObj != nil {
                    println(error)
                } else if let newObj = newObj {
                    newObj["eventColor"] = finishColor.description
                    newObj.saveInBackground()
                }
            }

        }
        completionHandler()

    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        var nc:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("DO_ACTION", object: self, userInfo: notification.userInfo)
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

