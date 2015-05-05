//
//  ViewController.swift
//  CalendarSw
//
//  Created by Shan Shawn on 4/6/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, JTCalendarDataSource {
    var newDate:NSDate = NSDate()
    
    @IBOutlet weak var maDayView: UIView!
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTCalendarContentView!
    var calendar: JTCalendar = JTCalendar()
    
    @IBAction func changeToToday(sender: UIButton) {
        self.calendar.currentDate = NSDate()
        
    }
    
    @IBAction func tapToday(sender: UIButton) {
        self.newDate=NSDate()
        self.performSegueWithIdentifier("dayDetail", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar = JTCalendar()
        self.calendar.menuMonthsView = self.calendarMenuView
        self.calendar.contentView = self.calendarContentView
        self.calendar.dataSource = self
        self.calendar.reloadData()
        let swiftColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
        
        let todayColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 0.7)
        
        let selectColor = UIColor(red:35/255, green:159/255, blue: 192/255, alpha: 1)
        
        // self.calendar.calendarAppearance.calendar.firstWeekday() = 2; // Monday
        
        //self.calendar.calendarAppearance.ratioContentMenu = 1;
        
       // self.calendar.calendarAppearance.menuMonthTextColor = UIColor.blackColor()
        
       // self.calendar.calendarAppearance.dayCircleColorSelected = UIColor.blackColor()
        
       // self.calendar.calendarAppearance.dayCircleColorSelectedOtherMonth = UIColor.blackColor()
        
        self.calendar.calendarAppearance.dayCircleColorToday = todayColor
        //self.calendar.contentView.backgroundColor = selectColor MONTH BG
        self.maDayView.backgroundColor = UIColor.blackColor()         
          //  topBackground.backgroundColor = todayColor
        //self.calendar.calendarAppearance.dayCircleColorTodayOtherMonth = UIColor.blackColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("alertView:"), name: "DO_ACTION", object: nil)
        
        //self.calendar.calendarAppearance.dayCircleColorToday = todayColor
        //self.calendar.calendarAppearance.dayTextColorSelected = UIColor.whiteColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        self.calendar.repositionViews()
    }
    func calendarHaveEvent(calendar: JTCalendar!, date: NSDate!) -> Bool {
        return false
    }
    func calendarDidDateSelected(calendar: JTCalendar!, date: NSDate!) {
        NSLog("%@", date)
        //let myData = Singleton.sharedInstance
        //myData.selectedDate = date
        self.newDate = date
        self.performSegueWithIdentifier("dayDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dayDetail"{
            let objectDate = self.newDate
            (segue.destinationViewController as DayDetailViewController).newDate = objectDate
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertView(notification:NSNotification){
        var alertController = UIAlertController(title: "Event Time!", message: "", preferredStyle: .Alert)
        var okAction = UIAlertAction(title: "Do Now", style: UIAlertActionStyle.Default) {
            UIAlertAction in
                println("OK Pressed")
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
            self.viewDidLoad() 
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
                println("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

