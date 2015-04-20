//
//  ViewController.swift
//  CalendarSw
//
//  Created by Shan Shawn on 4/6/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit

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
    @IBAction func changeToWeek(sender: UIButton) {
        self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode
        self.calendar.reloadAppearance()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar = JTCalendar()
        self.calendar.menuMonthsView = self.calendarMenuView
        self.calendar.contentView = self.calendarContentView
        self.calendar.dataSource = self
        self.calendar.reloadData()
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


}

