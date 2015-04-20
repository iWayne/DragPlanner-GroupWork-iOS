//
//  DayDetailViewController.swift
//  CalendarSw
//
//  Created by Shan Shawn on 4/18/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit

class DayDetailViewController: UIViewController,MADayViewDelegate,MADayViewDataSource {
    let CURRENT_CALENDAR = NSCalendar.currentCalendar()
    var eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    var _eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    var newDate:NSDate? = NSDate()
    var arrEvent:[MAEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addEvent(sender: UIButton) {
        var dayView2:MADayView = self.view as MADayView
        var setDate:NSDate = newDate!.dateByAddingTimeInterval(60*60*2)
        println("Detail Date: ")
        println(setDate.description)
        arrEvent.append(self.createEvent(setDate))
        dayView(dayView2, eventsForDate: setDate)
        dayView2.reloadData()
        arrEvent = []
    }
    
    override func viewDidAppear(animated: Bool) {
        if let date = self.newDate{
            //println(date.description)
            var dayView:MADayView = self.view as MADayView
            dayView.day = date as NSDate
            dayView.autoScrollToFirstEvent = true
            //self.dayView(dayView, eventsForDate: newDate! as NSDate)
        }
        
    }
    
    func dayView(dayView: MADayView!, eventsForDate date: NSDate!) -> [AnyObject]!
    {
        return arrEvent
    }
    
    func createEvent(date:NSDate)->MAEvent{
        //var r = arc4random()%24
        var event = MAEvent()
        event.textColor = UIColor.whiteColor()
        event.backgroundColor = UIColor.purpleColor()
        event.allDay = false
        event.title = "Here"
        event.start = date
        event.end = date.dateByAddingTimeInterval(60*60*1)
        //println(event.start.description)
        //println(event.end.description)
        return event
    }
    
}
