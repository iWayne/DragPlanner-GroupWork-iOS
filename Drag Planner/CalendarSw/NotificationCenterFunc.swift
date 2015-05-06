//
//  NotificationCenterFunc.swift
//  CalendarSw
//
//  Created by Shan Shawn on 5/3/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import Foundation

//At the beginning of the Event
func addNotiWithoutAction(maEvent:MAEvent){
    println("no action")
    var notification:UILocalNotification = UILocalNotification()
    notification.alertBody = "Event: \(maEvent.title)"
    notification.fireDate = maEvent.start
    notification.userInfo = maEvent.userInfo
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
}

//At the end of the Event
func addNotiWithAction(maEvent:MAEvent){
    println("action")
    var notification:UILocalNotification = UILocalNotification()
    notification.alertBody = "Event: \(maEvent.title)"
    notification.category = "FIRST_CATEGORY"
    notification.fireDate = maEvent.start
    notification.userInfo = maEvent.userInfo
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
}

func cancelNoti(maEvent:MAEvent){
    println("cancel")
    var eventInfo = maEvent.userInfo
    for noti in UIApplication.sharedApplication().scheduledLocalNotifications {
        //println(eventInfo)
        if((noti as UILocalNotification).userInfo!["key"] as NSString == eventInfo["key"] as NSString){
            UIApplication.sharedApplication().cancelLocalNotification(noti as UILocalNotification)
        }
    }
}