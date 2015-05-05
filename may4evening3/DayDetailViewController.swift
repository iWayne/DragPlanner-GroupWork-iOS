//
//  DayDetailViewController.swift
//  CalendarSw
//
//  Created by Shan Shawn on 4/18/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit
import Parse

class DayDetailViewController: UIViewController,MADayViewDelegate,MADayViewDataSource, UITextViewDelegate {
    
    let CURRENT_CALENDAR = NSCalendar.currentCalendar()
    var eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    var _eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    var newDate:NSDate? = NSDate()
    var arrEvent:[MAEvent] = []
    
    var oldCoordinate: CGPoint = CGPoint(x: 50, y: 56)
    var oldHeight: CGFloat = 100
    var oldWidth: CGFloat = 100
    var topY: CGFloat = 55
    var bottomY: CGFloat = 105
    var showAddView = false
    var tempEvent: MAEvent?
    var pinched = false
    var modifying = false
    var objId: String?
    var idMayDelete: String?
    var store:EKEventStore = EKEventStore()
    var tempEventForApple: MAEvent?
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var moveTextView: UITextView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    @IBOutlet weak var shareButton: UIButton!
    
    //View Definition
    //---------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.hidden = true
        oldWidth = self.view.bounds.size.width - 50 - timeLabel.bounds.width
        setMoveTextView()
        setAddView()
        addButton.hidden = false
        self.view.bringSubviewToFront(addButton)
        self.view.bringSubviewToFront(deleteButton)
        self.view.bringSubviewToFront(shareButton)
        addButton.frame = CGRectMake(0, 100, 100, 100)
        doneButton.hidden = false
        self.view.bringSubviewToFront(doneButton)
        doneButton.frame = CGRectMake(200, 100, 100, 100)
        // Do any additional setup after loading the view.
        moveTextView.setTranslatesAutoresizingMaskIntoConstraints(true)
        timeLabel.setTranslatesAutoresizingMaskIntoConstraints(true)
        timeLabel2.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        var swipeRightGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        var swipeLeftGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        (self.view as MADayView).gridView.addGestureRecognizer(swipeRightGesture)
        (self.view as MADayView).gridView.addGestureRecognizer(swipeLeftGesture)
        

    }
    
    override func viewDidAppear(animated: Bool) {
        if let date = self.newDate{
            //println(date.description)
            var dayView:MADayView = self.view as MADayView
            dayView.day = date as NSDate
            dayView.autoScrollToFirstEvent = false
            //self.dayView(dayView, eventsForDate: newDate! as NSDate)
            var tim: NSTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("changeDay"), userInfo: nil, repeats: true)
            moveTextView.textAlignment = NSTextAlignment.Center
            reloadEventFromBoth()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //---------------------------------------------------------------------------------------------------
    //MADayView Edit
    //---------------------------------------------------------------------------------------------------
    func dayView(dayView: MADayView!, eventsForDate date: NSDate!) -> [AnyObject]!
    {
        return arrEvent
    }
    
    func dayView(dayView: MADayView!, eventTapped event: MAEvent!) {
        
        //        removeEvent(event)
        //        dayView.reloadData()
        if event.backgroundColor == finishColor {
            return
        }
        removeEvent(event)
        addView.hidden = false
        moveTextView.hidden = false
        moveTextView.text = event.title
        moveTextView.textAlignment = NSTextAlignment.Center
        moveTextView.backgroundColor = gColor
        var formatter = NSDateFormatter();
        formatter.dateFormat = "HH:mm";
        var startT = formatter.stringFromDate(event.start)
        var endT = formatter.stringFromDate(event.end)
        var startHourAndMinite = split(startT){$0 == ":"}
        var endHourAndMinite = split(endT){$0 == ":"}
        var startSec = startHourAndMinite[0].toInt()! * 3600 + startHourAndMinite[1].toInt()! * 60
        var endSec = endHourAndMinite[0].toInt()! * 3600 + endHourAndMinite[1].toInt()! * 60
        var dayViewOffsetY = (self.view as MADayView).scrollView.contentOffset.y
        var topYY = Double(startSec)/3600 * 46.25 + 55.0 - Double(dayViewOffsetY)
        var endYY = Double(endSec)/3600 * 46.25 + 55.0 - Double(dayViewOffsetY)
        var height: CGFloat = CGFloat(endYY) - CGFloat(topYY)
        moveTextView.frame = CGRectMake(50, CGFloat(topYY), self.view.bounds.size.width - 20, height)
        deleteButton.hidden = false
        tempEvent = event
        addButton.hidden = true
        modifying = true
        
        println("tempEvent's ID: \(tempEvent?.eventID)")
        if tempEvent?.eventID != nil {
            var query = PFQuery(className: "event")
            query.whereKey("eventId", equalTo: tempEvent?.eventID)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            self.idMayDelete = object.objectId
                            self.moveTextView.backgroundColor = identifyColor(object["eventColor"] as String)
                            println("may delete: \(self.idMayDelete)")
                        }
                    }
                } else {
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
        }
        
    }
    
    func changeDay() {
        if(moveTextView.frame.origin.x > 150) {
            swipeLeft()
        } else if(moveTextView.frame.origin.x < -110) {
            swipeRight()
        }
    }
    
    func refreshView(){
        (self.view as MADayView).reloadData()
    }
    
    func reloadEventFromBoth(){
        arrEvent = []
        //modifying = false
        tempEventForApple = nil
        tempEvent = nil
        readFromAppleCalendar()
        showCurrentSchedule()
    }
    
    //---------------------------------------------------------------------------------------------------
    //Overwirte Swipe Right & Left
    //---------------------------------------------------------------------------------------------------
    func swipeRight() {
        var dayView:MADayView = self.view as MADayView
        newDate = dayView.previousDayFromDate(newDate)
        dayView.day = newDate
        println("Use Swipe Right")
        reloadEventFromBoth()
        
    }
    
    func swipeLeft() {
        var dayView:MADayView = self.view as MADayView
        newDate = dayView.nextDayFromDate(newDate)
        dayView.day = newDate
        println("Use Swipe Left")
        reloadEventFromBoth()
    }
    
    //---------------------------------------------------------------------------------------------------
    //Share Function
    //---------------------------------------------------------------------------------------------------
    func createCalendarEvent()->NHCalendarEvent{
        var calendarEvent:NHCalendarEvent = NHCalendarEvent()
        calendarEvent.startDate = changeCGFloatToTime(topY)
        calendarEvent.title = moveTextView.text
        calendarEvent.endDate = changeCGFloatToTime(bottomY)
        calendarEvent.allDay = false
        return calendarEvent
    }
    
    @IBAction func shareFunc(sender: AnyObject) {
        var event = self.createCalendarEvent()
        var formatter = NSDateFormatter();
        formatter.dateFormat = "MMM dd, yyyy HH:mm";
        var msg:NSString = "The event \(event.title) start at \(formatter.stringFromDate(event.startDate)) and end at \(formatter.stringFromDate(event.endDate))"
        var url:NSURL = NSURL(string: "")!
        var activities:NSArray = [NHCalendarActivity()]
        var items = [msg,url,event]
        var activity:UIActivityViewController = UIActivityViewController(activityItems: items, applicationActivities: activities)
        self.presentViewController(activity, animated: true, completion: nil)
    }

    //---------------------------------------------------------------------------------------------------
    //Read from Parse
    //---------------------------------------------------------------------------------------------------
    
    func showCurrentSchedule() {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        var current = dateFormatter.stringFromDate(newDate!)
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
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                        var stime = (object["startTime"] as NSDate).dateByAddingTimeInterval(4*60*60)
                        var etime = (object["endTime"] as NSDate).dateByAddingTimeInterval(4*60*60)
                        var color = object["eventColor"] as String
                        var title = object["eventContent"] as String
                        self.addEventByTime(stime, eTime: etime, color: identifyColor(color), eventid: object.objectId, title: title)
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        refreshView()
    }
    
    //---------------------------------------------------------------------------------------------------
    //Sync With Parse
    //---------------------------------------------------------------------------------------------------
    
    
    
    //---------------------------------------------------------------------------------------------------
    //Read from Apple Calendar
    //---------------------------------------------------------------------------------------------------
    
    func readFromAppleCalendar(){
        var oneDayAgo:NSDate = getMidnight(newDate!)
        var oneDayAfter: NSDate = oneDayAgo.dateByAddingTimeInterval(3600*24)
        store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted:Bool, error) -> Void in
            if(granted){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var predicate:NSPredicate = self.store.predicateForEventsWithStartDate(oneDayAgo, endDate: oneDayAfter, calendars: nil)
                    if(self.store.eventsMatchingPredicate(predicate) != nil) {
                        var events:NSArray = self.store.eventsMatchingPredicate(predicate)
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

    //---------------------------------------------------------------------------------------------------
    //MoveTextView Definition
    //---------------------------------------------------------------------------------------------------
    
    func setMoveTextView() {
        
        moveTextView.hidden = true
        timeLabel.hidden = true
        timeLabel2.hidden = true
        moveTextView.selectable = false
        moveTextView.text = ""
        moveTextView.layer.borderWidth = 1
        moveTextView.layer.borderColor = UIColor.redColor().CGColor
        moveTextView.layer.cornerRadius = 5
        moveTextView.backgroundColor = rColor
        moveTextView.delegate = self
        
        moveTextView.frame = CGRectMake(timeLabel.bounds.width, 100, self.view.bounds.size.width - 50, self.view.bounds.size.height - 200)
        self.view.bringSubviewToFront(moveTextView)
        self.view.bringSubviewToFront(timeLabel)
        self.view.bringSubviewToFront(timeLabel2)
    }
    
    func setAddView() {
        self.view.bringSubviewToFront(addView)
        addView.hidden = true
        addView.layer.borderWidth = 2
        addView.layer.borderColor = UIColor.grayColor().CGColor
        addView.layer.cornerRadius = 5
        addView.frame = CGRectMake(10, 300, 100, 200)
        
        redButton.backgroundColor = bColor
        greenButton.backgroundColor = rColor
        blueButton.backgroundColor = gColor
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            moveTextView.textAlignment = NSTextAlignment.Center
            moveTextView.resignFirstResponder()
            moveTextView.selectable = false
            moveTextView.editable = false
            println("return pressed")
//            if oldHeight == 100 {
//                oldHeight = moveTextView.contentSize.height
//            }
//            moveTextView.frame = CGRectMake(oldCoordinate.x, oldCoordinate.y, oldWidth, oldHeight)
            return false
        }
        return true
    }

    
    //---------------------------------------------------------------------------------------------------
    //All Buttons
    //---------------------------------------------------------------------------------------------------
    
    @IBAction func addEvent(sender: UIButton) {
        moveTextView.textAlignment = NSTextAlignment.Center
        addView.hidden = showAddView
        showAddView = !showAddView
        moveTextView.text = ""
    }
    
    @IBAction func doneButtonAction(sender: AnyObject) {
        //Modify Events
        
        if !moveTextView.hidden {
            var theEvent = MAEvent()
            moveTextView.hidden = true
            moveTextView.editable = false
            timeLabel.hidden = true
            timeLabel2.hidden = true
            deleteButton.hidden = true
            addView.hidden = true
            showAddView = false
            addButton.hidden = false
            
            if moveTextView.backgroundColor == gColor {
                if modifying {
                    var query = PFQuery(className:"event")
                    query.getObjectInBackgroundWithId(idMayDelete) {
                        (object: PFObject?, error: NSError?) -> Void in
                        if error != nil {
                            println(error)
                        } else if let object = object {
                            println("deleting object \(self.idMayDelete)")
                            object.deleteInBackground()
                        }
                    }
                }
                
                
                // apple func here
                theEvent = resetAppleEvent()
                saveToAppleCalendar(theEvent)
            }
            else if (!modifying)  {
                var username = "mewhuan"
                var testObject = PFObject(className: "event")
                testObject["username"] = username
                testObject["eventContent"] = moveTextView.text
                testObject["eventColor"] = moveTextView.backgroundColor?.description
                testObject["startTime"] = changeCGFloatToTime(self.moveTextView.frame.origin.y).dateByAddingTimeInterval(4*60*60*(-1))
                testObject["endTime"] = changeCGFloatToTime(self.moveTextView.frame.origin.y + self.moveTextView.bounds.height).dateByAddingTimeInterval(4*60*60*(-1))
                testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    println("Object has been saved.")
                    println("---------------")
                    println("id is: \(testObject.objectId)")
//                theEvent = self.addEventByDrop(self.topY, bottomY1: self.bottomY, eventid: testObject.objectId)
                    theEvent = self.addEventByDrop(self.moveTextView.frame.origin.y, bottomY1: self.moveTextView.frame.origin.y + self.moveTextView.bounds.height, eventid: testObject.objectId, title: self.moveTextView.text)
                    theEvent.eventID = testObject.objectId
                    testObject["eventId"] = theEvent.eventID
                    testObject.saveInBackground()
                }
            }
            else {
                println("id modifying: \(idMayDelete)")
                //println(self.moveTextView.frame.origin.y)
                
                var query = PFQuery(className: "event")
                query.getObjectInBackgroundWithId(idMayDelete) {
                    (newObj: PFObject?, error: NSError?) -> Void in
                    if error != nil && newObj != nil {
                        println(error)
                    } else if let newObj = newObj {
                        newObj["eventContent"] = self.moveTextView.text
                        newObj["eventColor"] = self.moveTextView.backgroundColor?.description
                        newObj["startTime"] = self.changeCGFloatToTime(self.moveTextView.frame.origin.y).dateByAddingTimeInterval(4*60*60*(-1))
                        newObj["endTime"] = self.changeCGFloatToTime(self.moveTextView.frame.origin.y + self.moveTextView.bounds.height).dateByAddingTimeInterval(4*60*60*(-1))
                        theEvent = self.addEventByDrop(self.moveTextView.frame.origin.y, bottomY1: self.moveTextView.frame.origin.y + self.moveTextView.bounds.height, eventid: newObj.objectId, title: self.moveTextView.text)
                        newObj.saveInBackground()
                    }
                }
                println("modification completed")
                //refreshView()
                
                if(tempEventForApple != nil){
                    removeFromAppleCalendar(tempEventForApple!)
                }
            }
            //Set Notifications
            //------------------------------------------------
            if(tempEvent != nil && tempEvent?.eventID != nil){
                cancelNoti(tempEvent!)
            }
            if(theEvent.eventID != nil){
                if(moveTextView.backgroundColor == rColor){
                    addNotiWithAction(theEvent)
                }
                if(moveTextView.backgroundColor == bColor){
                    addNotiWithoutAction(theEvent)
                }
            }
        }
        else {
            addView.hidden = true
        }
        resetMoveTextView()
        modifying  = false
        
      
        
    }
    
    @IBAction func redButtonAction(sender: AnyObject) {
        moveTextView.backgroundColor = redButton.backgroundColor
        moveTextView.layer.borderColor = UIColor.redColor().CGColor
        moveTextView.hidden = false
        moveTextView.editable = true
        moveTextView.becomeFirstResponder()
        deleteButton.hidden = false
        addButton.hidden = true
    }
    @IBAction func greenButtonAction(sender: AnyObject) {
        moveTextView.backgroundColor = greenButton.backgroundColor
        moveTextView.layer.borderColor = UIColor.yellowColor().CGColor
        moveTextView.hidden = false
        moveTextView.editable = true
        moveTextView.becomeFirstResponder()
        deleteButton.hidden = false
        addButton.hidden = true
    }
    @IBAction func blueButtonAction(sender: AnyObject) {
        moveTextView.backgroundColor = blueButton.backgroundColor
        moveTextView.layer.borderColor = UIColor.blueColor().CGColor
        moveTextView.hidden = false
        moveTextView.editable = true
        moveTextView.becomeFirstResponder()
        deleteButton.hidden = false
        addButton.hidden = true
    }

    
    @IBAction func deleteButtonAction(sender: AnyObject) {
        
        moveTextView.hidden = true
        if tempEvent != nil {
            removeEvent(tempEvent!)
        }
        if(tempEventForApple != nil){
            removeFromAppleCalendar(tempEventForApple!)
        }
        deleteButton.hidden = true
        moveTextView.editable = false
        addButton.hidden = false
        
        var query = PFQuery(className:"event")
        query.getObjectInBackgroundWithId(idMayDelete) {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let object = object {
                println("deleting object \(self.idMayDelete)")
                object.deleteInBackground()
            }
        }
        addView.hidden = true
        showAddView = false
    }
    
    //---------------------------------------------------------------------------------------------------
    //All Gesture
    //---------------------------------------------------------------------------------------------------
    
    @IBAction func handlePinchGesture(sender: AnyObject) {
        if !pinched {
            self.performSegueWithIdentifier("backToCalendar", sender: self)
            println("once")
            pinched = !pinched
        }

    }
    
    @IBAction func handleTapGesture(sender: AnyObject) {
        
        oldCoordinate = moveTextView.frame.origin
        oldHeight = moveTextView.bounds.height
        oldWidth = moveTextView.bounds.width
        println(moveTextView.frame.origin.x)
        println(oldCoordinate)
        moveTextView.becomeFirstResponder()
        moveTextView.editable = true

    }
    
    @IBAction func handlePanGesture(sender: AnyObject) {
        
        moveTextView.editable = false
        let location = sender.locationInView(self.view)
        //        moveTextView.center = location
        var h = moveTextView.bounds.height
        var w = moveTextView.bounds.width
        var x = moveTextView.frame.origin.x
        var y = moveTextView.frame.origin.y
        var newH = location.y - y
        if newH < 50 {
            newH = 50
        }
        moveTextView.frame = CGRectMake(x, y, w, newH)
        topY = y
        bottomY = y + newH
        //
        var formatter = NSDateFormatter();
        formatter.dateFormat = "HH:mm";
        timeLabel.text = formatter.stringFromDate(changeCGFloatToTime(topY))
        timeLabel2.text = formatter.stringFromDate(changeCGFloatToTime(bottomY))
        
        println("x: \(topY) y: \(bottomY)")
        timeLabel.frame = CGRectMake(moveTextView.center.x + moveTextView.bounds.width/2, moveTextView.center.y - moveTextView.bounds.height/2, timeLabel.bounds.width, timeLabel.bounds.height)
        timeLabel2.frame = CGRectMake(moveTextView.center.x + moveTextView.bounds.width/2, moveTextView.center.y + moveTextView.bounds.height/2 - timeLabel2.bounds.height, timeLabel2.bounds.width, timeLabel2.bounds.height)
        timeLabel.hidden = false
        timeLabel2.hidden = false
    }
    
    @IBAction func handleLongPressGesture(sender: AnyObject) {
        
        moveTextView.editable = false
//        moveTextView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.9)
        let location = sender.locationInView(self.view)
        moveTextView.center = location
        topY = moveTextView.frame.origin.y
        bottomY = topY + moveTextView.bounds.height
        
        //
        var formatter = NSDateFormatter();
        formatter.dateFormat = "HH:mm";
        timeLabel.text = formatter.stringFromDate(changeCGFloatToTime(topY))
        timeLabel2.text = formatter.stringFromDate(changeCGFloatToTime(bottomY))
        
        timeLabel.frame = CGRectMake(moveTextView.center.x + moveTextView.bounds.width/2, location.y - moveTextView.bounds.height/2, timeLabel.bounds.width, timeLabel.bounds.height)
        timeLabel2.frame = CGRectMake(moveTextView.center.x + moveTextView.bounds.width/2, location.y + moveTextView.bounds.height/2 - timeLabel2.bounds.height, timeLabel2.bounds.width, timeLabel2.bounds.height)
        println("x: \(topY) y: \(bottomY)")
        timeLabel.hidden = false
        timeLabel2.hidden = false
    }
    
    
    //---------------------------------------------------------------------------------------------------
    //Event Array Modification
    //---------------------------------------------------------------------------------------------------
    
    func changeCGFloatToTime(yPosition:CGFloat)->NSDate {
        var dayViewOffsetY = (self.view as MADayView).scrollView.contentOffset.y
        var offset = (yPosition - 55.0 + dayViewOffsetY )*3600/46.25
        var theTime = newDate?.dateByAddingTimeInterval(Double(offset))
        return theTime!
    }
    
    func addEventByDrop(topY1:CGFloat,bottomY1:CGFloat, eventid: String, title: String) -> MAEvent{
        var dayViewOffsetY = (self.view as MADayView).scrollView.contentOffset.y
        var startOffset = (topY1 - 55.0 + dayViewOffsetY )*3600/46.25
        var endOffset = (bottomY1 - 55.0 + dayViewOffsetY )*3600/46.25
        println("startOffSet:\(startOffset)")
        var startTime:NSDate? = newDate?.dateByAddingTimeInterval(Double(startOffset))
        var endTime:NSDate? = newDate?.dateByAddingTimeInterval(Double(endOffset))
        println(startTime!.description)
        println(endTime!.description)
        var theEvent = self.createEvent(startTime!, endTime: endTime!, color: moveTextView.backgroundColor!, eventid: eventid, title: title)
        arrEvent.append(theEvent)
        refreshView()
        return theEvent
    }
    
    func addEventByTime(sTime: NSDate, eTime: NSDate, color: UIColor, eventid: String, title: String) {
        arrEvent.append(self.createEvent(sTime, endTime: eTime, color: color, eventid: eventid, title: title))
        refreshView()
    }
    
    func removeEvent(event: MAEvent){
        if(event.appleEventID != nil){
            tempEventForApple = event
        }else{
            tempEventForApple = nil
        }
        var count: Int = -1
        var index: Int = -1
        for e in arrEvent {
            count++
            if(tempEventForApple != nil && e.appleEventID != nil && tempEventForApple?.appleEventID == e.appleEventID) {
                index = count
                break
            }else if(event.eventID != nil && e.eventID != nil && event.eventID == e.eventID){
                index = count
                break
            }
        }
        if index != -1 {
            arrEvent.removeAtIndex(index)
            refreshView()
        }
    }
    
    func hiddenEvent(event: MAEvent) {
        var count: Int = -1
        var index: Int = -1
        for e in arrEvent {
            count++
            if e.start == event.start && e.end == event.end {
                index = count
                println("found u")
                e.backgroundColor = UIColor.whiteColor()
                refreshView()
                break
            }
        }
    }
    
    func createEvent(startT:NSDate, endTime:NSDate, color: UIColor, eventid: String, title: String)->MAEvent{
        //var r = arc4random()%24
        var event = MAEvent()
        event.textColor = UIColor.whiteColor()
        event.backgroundColor = color
        event.allDay = false
        event.title = title
        event.start = startT
        event.end = endTime
        event.eventID = eventid
        //println(startT.description)
        //println(endTime.description)
        return event
    }
    
    func resetAppleEvent()->MAEvent{
        var event = self.addEventByDrop(self.moveTextView.frame.origin.y, bottomY1: self.moveTextView.frame.origin.y + self.moveTextView.bounds.height, eventid: "", title: self.moveTextView.text)
        if(modifying && tempEventForApple != nil){
            event.appleEventID = tempEventForApple!.appleEventID
        }
        return event
    }
    
    //---------------------------------------------------------------------------------------------------
    //Save to Apple Calendar
    //---------------------------------------------------------------------------------------------------
    func saveToAppleCalendar(maEvent:MAEvent){
        store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted:Bool, error) -> Void in
            if(granted){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if(maEvent.appleEventID != nil){
                        var ekEventRemoved:EKEvent = self.store.eventWithIdentifier(maEvent.appleEventID)
                        self.store.removeEvent(ekEventRemoved, span: EKSpanThisEvent, error: nil)
                    }
                    self.store.saveEvent(self.convertMAEvent2EKEvent(maEvent), span: EKSpanThisEvent, error: nil)
                    self.reloadEventFromBoth()
                })
                
            }else{
                println("no way")
            }
        })
        
    }
    
    //---------------------------------------------------------------------------------------------------
    //Remove Event from Apple Calendar
    //---------------------------------------------------------------------------------------------------
    func removeFromAppleCalendar(maEvent:MAEvent){
        store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted:Bool, error) -> Void in
            if(granted){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(maEvent.appleEventID != nil){
                        println("remove")
                        var ekEventRemoved:EKEvent = self.store.eventWithIdentifier(maEvent.appleEventID)
                        println(ekEventRemoved.eventIdentifier)
                        self.store.removeEvent(ekEventRemoved, span: EKSpanThisEvent, error: nil)
                    }
                    self.reloadEventFromBoth()
                })
            }else{
                println("no way")
            }
        })
        
    }

    func resetMoveTextView() {
        moveTextView.frame = CGRectMake(50, 56, self.view.bounds.size.width - 20, self.view.bounds.size.height - 200)
    }
    
    
    func convertMAEvent2EKEvent(maEvent:MAEvent)->EKEvent{
        var ekEvent:EKEvent = EKEvent(eventStore: store)
        ekEvent.startDate = maEvent.start
        ekEvent.endDate = maEvent.end
        ekEvent.title = maEvent.title
        ekEvent.allDay = false
        ekEvent.calendar = store.defaultCalendarForNewEvents
        return ekEvent
    }
    
    
    
    //---------------------------------------------------------------------------------------------------
    //Others
    //---------------------------------------------------------------------------------------------------
    
//    func alert() {
//        
//        var alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
//        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
//            UIAlertAction in
//            println("OK Pressed")
//        }
//        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
//            UIAlertAction in
//            println("Cancel Pressed")
//        }
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
//
}
