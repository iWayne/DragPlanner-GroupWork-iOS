//
//  DayDetailViewController.swift
//  CalendarSw
//
//  Created by Shan Shawn on 4/18/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit

class DayDetailViewController: UIViewController,MADayViewDelegate,MADayViewDataSource, UITextViewDelegate {
    
    let CURRENT_CALENDAR = NSCalendar.currentCalendar()
    var eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    var _eventKitDataSource:MAEventKitDataSource = MAEventKitDataSource()
    var newDate:NSDate? = NSDate()
    var arrEvent:[MAEvent] = []
    var startTime: String = ""
    var endTime: String = ""
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    var oldCoordinate: CGPoint = CGPoint(x: 50, y: 500)
    var oldHeight: CGFloat = 100
    var oldWidth: CGFloat = 100
    var topY: CGFloat = 55
    var bottomY: CGFloat = 105
    var showAddView = false
    var tempEvent: MAEvent?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var moveTextView: UITextView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.hidden = true
        oldWidth = self.view.bounds.size.width - 50 - timeLabel.bounds.width
        setMoveTextView()
        setAddView()
        addButton.hidden = false
        self.view.bringSubviewToFront(addButton)
        self.view.bringSubviewToFront(deleteButton)
        addButton.frame = CGRectMake(0, 100, 100, 100)
        doneButton.hidden = false
        self.view.bringSubviewToFront(doneButton)
        doneButton.frame = CGRectMake(200, 100, 100, 100)
        // Do any additional setup after loading the view.
        moveTextView.setTranslatesAutoresizingMaskIntoConstraints(true)
        timeLabel.setTranslatesAutoresizingMaskIntoConstraints(true)
        timeLabel2.setTranslatesAutoresizingMaskIntoConstraints(true)
        
//        var tapScrollView: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "donedone")
//        (self.view as MADayView).scrollView.addGestureRecognizer(tapScrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMoveTextView() {
        
        moveTextView.hidden = true
        timeLabel.hidden = true
        timeLabel2.hidden = true
        moveTextView.selectable = false
        moveTextView.text = ""
        moveTextView.layer.borderWidth = 1
        moveTextView.layer.borderColor = UIColor.redColor().CGColor
        moveTextView.layer.cornerRadius = 5
        moveTextView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
        moveTextView.delegate = self

        moveTextView.frame = CGRectMake(timeLabel.bounds.width, 100, self.view.bounds.size.width - 20, self.view.bounds.size.height)
        self.view.bringSubviewToFront(moveTextView)
        self.view.bringSubviewToFront(timeLabel)
        self.view.bringSubviewToFront(timeLabel2)
    }
    
    func setAddView() {
        
        //        addView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png"))
        self.view.bringSubviewToFront(addView)
        addView.hidden = true
        addView.layer.borderWidth = 2
        addView.layer.borderColor = UIColor.brownColor().CGColor
        addView.layer.cornerRadius = 5
        addView.frame = CGRectMake(10, 300, 100, 200)
        
        
        let bColor = UIColor(red:229/255, green:155/255, blue: 155/255, alpha: 0.7)
        let rColor = UIColor(red:242/255, green:193/255, blue: 24/255, alpha: 0.7)
        let gColor = UIColor(red:142/255, green:201/255, blue: 188/255, alpha: 0.7)
        
        redButton.backgroundColor = bColor
        greenButton.backgroundColor = rColor
        blueButton.backgroundColor = gColor
    }
    
    @IBAction func doneButtonAction(sender: AnyObject) {
        println(topY)
        println(bottomY)
        if !moveTextView.hidden {
            self.addEventByDrop(topY, bottomY1: bottomY)
        }
        moveTextView.hidden = true
        timeLabel.hidden = true
        timeLabel2.hidden = true
        deleteButton.hidden = true
        addView.hidden = true
        showAddView = false
//        newDate = (self.view as MADayView).day
//        dayView(self.view as MADayView, eventsForDate: newDate)
//        (self.view as MADayView).reloadData()

    }
    @IBAction func redButtonAction(sender: AnyObject) {
        moveTextView.backgroundColor = redButton.backgroundColor
        moveTextView.layer.borderColor = UIColor.redColor().CGColor
        moveTextView.hidden = false
        moveTextView.editable = true
        moveTextView.becomeFirstResponder()
        deleteButton.hidden = false
    }
    @IBAction func greenButtonAction(sender: AnyObject) {
        moveTextView.backgroundColor = greenButton.backgroundColor
        moveTextView.layer.borderColor = UIColor.greenColor().CGColor
        moveTextView.hidden = false
        moveTextView.editable = true
        moveTextView.becomeFirstResponder()
        deleteButton.hidden = false
    }
    @IBAction func blueButtonAction(sender: AnyObject) {
        moveTextView.backgroundColor = blueButton.backgroundColor
        moveTextView.layer.borderColor = UIColor.blueColor().CGColor
        moveTextView.hidden = false
        moveTextView.editable = true
        moveTextView.becomeFirstResponder()
        deleteButton.hidden = false
    }

    
    @IBAction func deleteButtonAction(sender: AnyObject) {
        
        moveTextView.hidden = true
        if tempEvent != nil {
            removeEvent(tempEvent!)
        }
        deleteButton.hidden = true
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
        changeCGFloatToTime()
        timeLabel.text = startTime
        timeLabel2.text = endTime
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
        changeCGFloatToTime()
        timeLabel.text = startTime
        timeLabel2.text = endTime
        timeLabel.frame = CGRectMake(moveTextView.center.x + moveTextView.bounds.width/2, location.y - moveTextView.bounds.height/2, timeLabel.bounds.width, timeLabel.bounds.height)
        timeLabel2.frame = CGRectMake(moveTextView.center.x + moveTextView.bounds.width/2, location.y + moveTextView.bounds.height/2 - timeLabel2.bounds.height, timeLabel2.bounds.width, timeLabel2.bounds.height)
        println("x: \(topY) y: \(bottomY)")
        timeLabel.hidden = false
        timeLabel2.hidden = false
    }
    @IBAction func addEvent(sender: UIButton) {
//        var dayView2:MADayView = self.view as MADayView
//        var setDate:NSDate = newDate!.dateByAddingTimeInterval(60*60*2)
//        println("Detail Date: ")
//        println(setDate.description)
//        arrEvent.append(self.createEvent(setDate))
//        dayView(dayView2, eventsForDate: setDate)
//        dayView2.reloadData()
//        arrEvent = []
//        moveTextView.hidden = false
//        moveTextView.editable = true
//        moveTextView.becomeFirstResponder()
//        println("dsfdfdsf")
        addView.hidden = showAddView
        showAddView = !showAddView
    }
    
    func donedone(){
        
    }
    
    func changeDay() {
        if(moveTextView.frame.origin.x > 150) {
            var dayView: MADayView = self.view as MADayView
            newDate = dayView.nextDayFromDate(newDate)
            dayView.day = newDate
        } else if(moveTextView.frame.origin.x < -110) {
            var dayView: MADayView = self.view as MADayView
            newDate = dayView.previousDayFromDate(newDate)
            dayView.day = newDate
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            moveTextView.textAlignment = NSTextAlignment.Center
            moveTextView.resignFirstResponder()
            moveTextView.selectable = false
            moveTextView.editable = false
            println("return pressed")
            if oldHeight == 100 {
                oldHeight = moveTextView.contentSize.height
            }
            moveTextView.frame = CGRectMake(oldCoordinate.x, oldCoordinate.y, oldWidth, oldHeight)
            return false
        }
        return true
    }

    override func viewDidAppear(animated: Bool) {
        if let date = self.newDate{
            //println(date.description)
            var dayView:MADayView = self.view as MADayView
            dayView.day = date as NSDate
            dayView.autoScrollToFirstEvent = false
            //self.dayView(dayView, eventsForDate: newDate! as NSDate)
            var tim: NSTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("changeDay"), userInfo: nil, repeats: true)
            
        }
        
    }
    
    func changeCGFloatToTime() {
        var dayViewOffsetY = (self.view as MADayView).scrollView.contentOffset.y
        var startOffset = (topY - 55.0 + dayViewOffsetY )*3600/46.25
        var endOffset = (bottomY - 55.0 + dayViewOffsetY)*3600/46.25
        var theStartTime = newDate?.dateByAddingTimeInterval(Double(startOffset))
        var theEndTime = newDate?.dateByAddingTimeInterval(Double(endOffset))
        var formatter = NSDateFormatter();
        formatter.dateFormat = "HH:mm";
        startTime = formatter.stringFromDate(theStartTime!)
        endTime = formatter.stringFromDate(theEndTime!)
    }
    
    func dayView(dayView: MADayView!, eventsForDate date: NSDate!) -> [AnyObject]!
    {
        return arrEvent
    }
    
    func addEventByDrop(topY1:CGFloat,bottomY1:CGFloat){
        var dayViewOffsetY = (self.view as MADayView).scrollView.contentOffset.y
        var startOffset = (topY1 - 55.0 + dayViewOffsetY )*3600/46.25
        var endOffset = (bottomY1 - 55.0 + dayViewOffsetY )*3600/46.25
        println("startOffSet:\(startOffset)")
        var startTime:NSDate? = newDate?.dateByAddingTimeInterval(Double(startOffset))
        var endTime:NSDate? = newDate?.dateByAddingTimeInterval(Double(endOffset))
        println(startTime!.description)
        println(endTime!.description)
        arrEvent.append(self.createEvent(startTime!, endTime: endTime!, color: moveTextView.backgroundColor!))
        var dayView:MADayView = self.view as MADayView
        dayView.reloadData()
    }

    func dayView(dayView: MADayView!, eventTapped event: MAEvent!) {

//        removeEvent(event)
//        dayView.reloadData()
        removeEvent(event)
        moveTextView.hidden = false
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
        println("\(startSec) , \(endSec)")
        deleteButton.hidden = false
        tempEvent = event
    }
    
    func removeEvent(event: MAEvent){
        var count: Int = -1
        var index: Int = -1
        for e in arrEvent {
            count++
            if e.start == event.start && e.end == event.end {
                index = count
                break
            }
        }
        if index != -1 {
            arrEvent.removeAtIndex(index)
            (self.view as MADayView).reloadData()
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
                (self.view as MADayView).reloadData()
                break
            }
        }

    }
    
    func createEvent(startT:NSDate, endTime:NSDate, color: UIColor)->MAEvent{
        //var r = arc4random()%24
        var event = MAEvent()
        event.textColor = UIColor.whiteColor()
        event.backgroundColor = color
        event.allDay = false
        event.title = "Here"
        event.start = startT
        event.end = endTime
        println(startT.description)
        println(endTime.description)
        return event
    }
    
}
