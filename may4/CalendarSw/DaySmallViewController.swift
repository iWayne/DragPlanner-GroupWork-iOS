//
//  DaySmallViewController.swift
//  CalendarSw
//
//  Created by Shan Shawn on 4/18/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit
import Parse

class DaySmallViewController: UIViewController,MADayViewDelegate,MADayViewDataSource {
    var newDate:NSDate = NSDate()
    var arrEvent:[MAEvent] = []
    let CURRENT_CALENDAR = NSCalendar.currentCalendar()
    var eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    var _eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        var dayView:MADayView = self.view as MADayView
        dayView.autoScrollToFirstEvent = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadEventFromBoth()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dayView(dayView: MADayView!, eventsForDate date: NSDate!) -> [AnyObject]! {
        //        newDate = date
        //        var arr:NSArray = [self.createEvent()]
        //        println(arr.count)
        //        return arr
        return arrEvent
    }
    
    func reloadEventFromBoth(){
        arrEvent = []
        readFromAppleCalendar()
        showCurrentSchedule()
    }
    
    func createEvent(startT:NSDate, endTime:NSDate, color: UIColor, title: String)->MAEvent{
        //var r = arc4random()%24
        var event = MAEvent()
        event.textColor = UIColor.whiteColor()
        event.backgroundColor = color
        event.allDay = false
        event.title = title
        event.start = startT
        event.end = endTime
        println(startT.description)
        println(endTime.description)
        return event
    }
    
    func showCurrentSchedule() {
        
        arrEvent.removeAll(keepCapacity: true)
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        var current = dateFormatter.stringFromDate(newDate)
        var currents = split(current){$0 == " "}
        var currentDay = currents[0]
        var currentDay1 = dateFormatter.dateFromString(currentDay + " 00:00:00")?.dateByAddingTimeInterval(4*60*60*(-1))
        var currentDay2 = currentDay1?.dateByAddingTimeInterval(60*60*24)
        println(currentDay1)
        println(currentDay2)
        var query = PFQuery(className:"event")
        query.whereKey("startTime", greaterThan: currentDay1)
        query.whereKey("endTime", lessThan: currentDay2)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) data.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                        var stime = (object["startTime"] as NSDate).dateByAddingTimeInterval(4*60*60)
                        var etime = (object["endTime"] as NSDate).dateByAddingTimeInterval(4*60*60)
                        var color = object["eventColor"] as String
                        var title = object["eventContent"] as String
                        self.addEventByTime(stime, eTime: etime, color: self.identifyColor(color), title: title)
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
    }
    
    func addEventByTime(sTime: NSDate, eTime: NSDate, color: UIColor, title: String) {
        //        arrEvent.removeAll(keepCapacity: true)
        arrEvent.append(self.createEvent(sTime, endTime: eTime, color: color, title: title))
        var dayView:MADayView = self.view as MADayView
        dayView.reloadData()
    }
    
    func identifyColor(colorCode: String) -> UIColor {
        
        if colorCode == "UIDeviceRGBColorSpace 0.898039 0.607843 0.607843 0.7" {
            return bColor
        }
        else if colorCode == "UIDeviceRGBColorSpace 0.94902 0.756863 0.0941176 0.7" {
            return rColor
        }
        else if colorCode == "UIDeviceRGBColorSpace 0.556863 0.788235 0.737255 0.7" {
            return gColor
        }
        else if colorCode == "UIDeviceRGBColorSpace 0 1 0 1" {
            return finishColor
        }
        return finishColor
    }

    //---------------------------------------------------------------------------------------------------
    //Read from Apple Calendar
    //---------------------------------------------------------------------------------------------------
    
    func readFromAppleCalendar(){
        var oneDayAgo:NSDate = getMidnight()
        var oneDayAfter: NSDate = oneDayAgo.dateByAddingTimeInterval(3600*24)
        var store:EKEventStore = EKEventStore()
        store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted:Bool, error) -> Void in
            if(granted){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var predicate:NSPredicate = store.predicateForEventsWithStartDate(oneDayAgo, endDate: oneDayAfter, calendars: nil)
                    if(store.eventsMatchingPredicate(predicate) != nil) {
                        var events:NSArray = store.eventsMatchingPredicate(predicate)
                        for event in events {
                            if(!(event as EKEvent).allDay){
                                self.arrEvent.append(self.assignEvent(event as EKEvent))
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
    
    func assignEvent(eventInput:EKEvent)->MAEvent{
        var event = MAEvent()
        event.title = eventInput.title
        event.start = eventInput.startDate
        event.end = eventInput.endDate
        event.allDay = eventInput.allDay
        //if(eventInput.hasAlarms){}
        event.appleEventID = eventInput.eventIdentifier
        event.backgroundColor = gColor
        return event
    }

}
