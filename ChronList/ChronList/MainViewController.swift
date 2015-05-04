//
//  MainViewController.swift
//  ChronList
//
//  Created by Shan Shawn on 4/17/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit
import EventKit

class MainViewController: UIViewController,MADayViewDelegate,MADayViewDataSource,NHCalendarActivityDelegate{
    var newDate:NSDate = NSDate()
    let CURRENT_CALENDAR = NSCalendar.currentCalendar()
    var eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    var _eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    var arr:[MAEvent] = []
    var tempEvent:MAEvent = MAEvent()
    var store:EKEventStore = EKEventStore()
    //var sv:UIScrollView = UIScrollView()
    
    @IBOutlet weak var uiView: MADayView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var fr:CGRect = CGRectMake(0, 0, 400, 400)
        (self.view as MADayView).autoScrollToFirstEvent = true
        
        //arr = readFromAppleCalendar(newDate)
        
        //Overwirte the Swipe Gesture
        //----------------------------------------------------------------------------------------------
        var tapScrollView: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        tapScrollView.direction = UISwipeGestureRecognizerDirection.Right
        (self.view as MADayView).gridView.addGestureRecognizer(tapScrollView)
        //----------------------------------------------------------------------------------------------
        //var tapGridView: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "donedone")
        //(self.view as MADayView).scrollView.addGestureRecognizer(tapGridView)
        //(self.view as MADayView).scrollView.canCancelContentTouches = false
        
        
        //Set Alarm
        //---------------------------------------------------------------------------------
        var date = NSDate().dateByAddingTimeInterval(5)
        
        var notification:UILocalNotification = UILocalNotification()
        notification.category = "FIRST_CATEGORY"
        notification.alertBody = "Hello World"
        notification.fireDate = date
        var aui: NSDictionary = NSDictionary(object: "hehe", forKey: "key")
        notification.userInfo = aui
        //NSNotificationCenter.postNotificationName(notification)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        //Cancel Alarm
        //---------------------------------------------------------------------------------
        /*
        for noti in UIApplication.sharedApplication().scheduledLocalNotifications {
            var userinfo:NSString = (noti as UILocalNotification).userInfo!["key"]! as NSString
            println("cancal \(userinfo)")
            if( userinfo == "hehe"){
                UIApplication.sharedApplication().cancelLocalNotification(noti as UILocalNotification)
            }
        }
        */
        //---------------------------------------------------------------------------------
        //readFromAppleCalendar()
        println("after read")
    }
    
    func donedone(){
        var calendar:NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        var comp:NSDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: NSDate())
        let newDate:NSDate = calendar.dateFromComponents(comp)!
        println(newDate)
    }
    
    
    
    func drawAShape(notification: NSNotification){
        println("Later Button")
    }
    func showAMessage(notification: NSNotification){
        println("finish Button")
    }
    
    func dayView(dayView: MADayView!, eventTapped event: MAEvent!) {
        println("tap event")
        println(event.userInfo["key"]! as NSString)
        println(event.eventID)
    }
    
    //Swipe Right
    func swipeRight() {
        var dayView:MADayView = self.view as MADayView
        newDate = dayView.previousDayFromDate(newDate)
        dayView.day = newDate
        println("Use Swipe Right")
    }
    //Share Function
    //---------------------------------------------------------------------------------------------------
    func createCalendarEvent()->NHCalendarEvent{
        var calendarEvent:NHCalendarEvent = NHCalendarEvent()
        
        calendarEvent.startDate = arr[0].start
        calendarEvent.title = arr[0].title
        calendarEvent.endDate = arr[0].end
        calendarEvent.allDay = false
        return calendarEvent
    }
    
    @IBAction func shareFunc(sender: AnyObject) {
        var msg:NSString = "Not\nhing"
        var url:NSURL = NSURL(string: "")!
        var activities:NSArray = [NHCalendarActivity()]
        //calendarActivity.delegate = self
        //var activities = [calendarActivity]
        
        
        var items = [msg,url,self.createCalendarEvent()]
        var activity:UIActivityViewController = UIActivityViewController(activityItems: items, applicationActivities: activities)
        self.presentViewController(activity, animated: true, completion: nil)
        
    }
    
    //Read Data From Apple Calendar
    //----------------------------------------------------------------------------------------------------------------
   
    @IBAction func printSCRO(sender: UIButton) {
        var oneDayAgo:NSDate = NSDate().dateByAddingTimeInterval(-3600*24)
        var oneDayAfter: NSDate = NSDate().dateByAddingTimeInterval(3600*24)
        store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted:Bool, error) -> Void in
            if(granted){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var predicate:NSPredicate = self.store.predicateForEventsWithStartDate(oneDayAgo, endDate: oneDayAfter, calendars: nil)
                    if(self.store.eventsMatchingPredicate(predicate) != nil) {
                        var events:NSArray = self.store.eventsMatchingPredicate(predicate)
                        for event in events {
                            if(self.checkEventID((event as EKEvent).eventIdentifier)){
                                self.arr.append(self.assignEvent(event as EKEvent))
                            }
                        }
                        (self.view as MADayView).reloadData()
                    }
                })
            }else{
                println("no way")
            }
        })
    }
    
    func getMidnight()->NSDate{
        var calendar:NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        var comp:NSDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: NSDate())
        return calendar.dateFromComponents(comp)!
    }
    //---------------------------------------------------------------------------------------------------
    //Save to Apple Calendar
    //---------------------------------------------------------------------------------------------------
    func saveToAppleCalendar(){
        store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted:Bool, error) -> Void in
            if(granted){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(self.tempEvent.appleEventID != nil){
                        //Modify
                    }else{
                        
                    }
                })
            }else{
                println("no way")
            }
        })
    }
    
    func convertMAEvent2EKEvent(maEvent:MAEvent)->EKEvent{
        var ekEvent:EKEvent = EKEvent();
        ekEvent.startDate = maEvent.start
        ekEvent.endDate = maEvent.end
        ekEvent.title = maEvent.title
        return ekEvent
    }
    
    
    //----------------------------------------------------------------------------------------------------------------
    
    func readFromAppleCalendar(){
        var store:EKEventStore = EKEventStore()
        var oneDayAgo:NSDate = getMidnight()
        var oneDayAfter: NSDate = oneDayAgo.dateByAddingTimeInterval(3600*24)
        store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted:Bool, error) -> Void in
            if(granted){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var predicate:NSPredicate = store.predicateForEventsWithStartDate(oneDayAgo, endDate: oneDayAfter, calendars: nil)
                    if(store.eventsMatchingPredicate(predicate) != nil) {
                        var events:NSArray = store.eventsMatchingPredicate(predicate)
                        for event in events {
                            if(self.checkEventID((event as EKEvent).eventIdentifier)){
                                self.arr.append(self.assignEvent(event as EKEvent))
                            }
                        }
                        (self.view as MADayView).reloadData()
                    }
                })
            }else{
                println("no way")
            }
        })
    }
    
    func checkEventID(eID:NSString)->Bool{
        for event in arr{
            if(event.eventID != nil && event.eventID == eID) {return false}
        }
        return true
    }
    
    func assignEvent(eventInput:EKEvent)->MAEvent{
        var event = MAEvent()
        event.title = eventInput.title
        event.start = eventInput.startDate
        event.end = eventInput.endDate
        event.allDay = eventInput.allDay
        //if(eventInput.hasAlarms){}
        event.eventID = eventInput.eventIdentifier
        event.backgroundColor = gColor
        return event
    }
    //--------------------------------------------------------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dayView(dayView: MADayView!, eventsForDate date: NSDate!) -> [AnyObject]! {
        //newDate = date
        //var arr:NSArray = [self.createEvent()]
        //println(arr.count)
        //arr.append(self.createEvent())
        return arr
    }
    
    
    func createEvent()->MAEvent{
        //var r = arc4random()%24
        var event = MAEvent()
        event.textColor = UIColor.whiteColor()
        event.backgroundColor = UIColor.purpleColor()
        event.allDay = false
        event.title = "Here"
        event.start = NSDate()
        event.end = NSDate().dateByAddingTimeInterval(60*60*1)
        //println(event.start.description)
        //println(event.end.description)
        return event
    }
    
    

}
