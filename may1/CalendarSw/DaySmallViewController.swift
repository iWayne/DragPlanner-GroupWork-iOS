//
//  DaySmallViewController.swift
//  CalendarSw
//
//  Created by Shan Shawn on 4/18/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit

class DaySmallViewController: UIViewController,MADayViewDelegate,MADayViewDataSource {
    var newDate:NSDate = NSDate()
    let CURRENT_CALENDAR = NSCalendar.currentCalendar()
    var eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    var _eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        var dayView:MADayView = self.view as MADayView
        dayView.autoScrollToFirstEvent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dayView(dayView: MADayView!, eventsForDate date: NSDate!) -> [AnyObject]! {
        newDate = date
        var arr:NSArray = [self.createEvent()]
        println(arr.count)
        return arr
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

}
