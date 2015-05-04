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
        showCurrentSchedule()
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
    
    func dayView(dayView: MADayView!, eventsForDate date: NSDate!) -> NSArray {
        newDate = date
        var arr:NSArray = [self.createEvent()]
        println(arr.count)
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
        println(event.start.description)
        println(event.end.description)
        return event
    }
    
    func createEvent(startT:NSDate, endTime:NSDate, color: UIColor)->MAEvent{
        //var r = arc4random()%24
        var event = MAEvent()
        event.textColor = UIColor.whiteColor()
        event.backgroundColor = color
        event.allDay = false
        event.title = "aaa"
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
                        self.addEventByTime(stime, eTime: etime, color: color)
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
    }
    
    func addEventByTime(sTime: NSDate, eTime: NSDate, color: String) {
        //        arrEvent.removeAll(keepCapacity: true)
        arrEvent.append(self.createEvent(sTime, endTime: eTime, color: UIColor.blackColor()))
        var dayView:MADayView = self.view as MADayView
        dayView.reloadData()
    }


}