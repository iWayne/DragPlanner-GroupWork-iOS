//
//  MissingTableView.swift
//  ChronList
//
//  Created by Shan Shawn on 5/4/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit
import Parse

class MissingTableView: UITableViewController,UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate, UIActionSheetDelegate {
    var eventsMissed:[MAEvent] = []
    var index: Int?
    var startDate:NSDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readMissingEvent()
        var backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("donedone"))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Missing Events"
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: Selector("toggleCells"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func didReceiveMemoryWarning() {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gotoMain"){
            segue.destinationViewController as! ViewController
        }else if(segue.identifier == "seeDetail"){
            (segue.destinationViewController as! DayDetailViewController).newDate = startDate
        }
    }
    
    
    func donedone(){
        self.performSegueWithIdentifier("gotoMain", sender: self)
    }

    /*
    func rightButtonsArray()->[AnyObject]{
        var buttons:[AnyObject] = []
        buttons.append(MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor()))
        buttons.append(MGSwipeButton(title: "More", backgroundColor: UIColor.lightGrayColor()))
        return buttons
    }*/
    
    //---------------------------------------------------------------------------------------------------
    //Cell Functions
    //---------------------------------------------------------------------------------------------------
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        switch(index){
        case 0:
            crossButtonAction(cell)
            break;
        case 1:
            listButtonAction(cell)
            break;
        case 2:
            checkButtonAction(cell)
            break;
        default:
            break;
        }
        return true
    }
    
    func rightButtonsArray()->[AnyObject]{
        var buttons:[AnyObject] = []
        buttons.append(MGSwipeButton(title: "", icon: UIImage(named: "cross.png"), backgroundColor: UIColor(red: 1.0, green: 0.231, blue: 0.188, alpha: 1.0)))
        buttons.append(MGSwipeButton(title: "", icon: UIImage(named: "list.png"), backgroundColor: UIColor(red: 1.0, green: 1.0, blue: 0.35, alpha: 1.0)))
        buttons.append(MGSwipeButton(title: "", icon: UIImage(named: "check.png"), backgroundColor: UIColor(red: 0.07, green: 0.75, blue: 0.16, alpha: 1.0)))
        return buttons
    }
    
    func readMissingEvent(){
        //Download from Parse
        var now = NSDate().dateByAddingTimeInterval(4*3600)
        var query = PFQuery(className: "event")
        query.whereKey("startTime", lessThan: now)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        if self.identifyColor(object["eventColor"]as! String) == bColor {
                            println(object.objectId)
                            var stime = (object["startTime"] as! NSDate).dateByAddingTimeInterval(4*60*60)
                            var etime = (object["endTime"] as! NSDate).dateByAddingTimeInterval(4*60*60)
                            var title = object["eventContent"] as! String
                            var event = MAEvent()
                            event.title = title
                            event.start = stime
                            event.end = etime
                            event.eventID = object.objectId
                            self.eventsMissed.append(event)
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }

    }
    
    func checkButtonAction(cell:MGSwipeTableCell){
        //Change the background of the Event event from Parse
        index = self.tableView.indexPathForCell(cell)?.row
        println("change BK")
        var event = eventsMissed[index!]
        var query = PFQuery(className: "event")
        query.getObjectInBackgroundWithId(event.eventID) {
            (newObj: PFObject?, error: NSError?) -> Void in
            if error != nil && newObj != nil {
                println(error)
            } else if let newObj = newObj {
                newObj["eventColor"] = finishColor.description
                newObj.saveInBackground()
            }
        }
        eventsMissed.removeAtIndex(index!)
        self.tableView.reloadData()
    }
    
    func crossButtonAction(cell:MGSwipeTableCell){
        //Delete event from Parse
        //println("Delete Event")
        index = self.tableView.indexPathForCell(cell)?.row
        var event = eventsMissed[index!]
        var query = PFQuery(className: "event")
        query.getObjectInBackgroundWithId(event.eventID) {
            (newObj: PFObject?, error: NSError?) -> Void in
            if error != nil && newObj != nil {
                println(error)
            } else if let newObj = newObj {
                newObj.deleteInBackground()
            }
        }
        eventsMissed.removeAtIndex(index!)
        self.tableView.reloadData()
    }
    
    func listButtonAction(cell:MGSwipeTableCell){
        //Go to Timeline View
        index = self.tableView.indexPathForCell(cell)?.row
        startDate = eventsMissed[index!].start
        self.performSegueWithIdentifier("seeDetail", sender: self)
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
        else {
            return finishColor
        }
    }

    //---------------------------------------------------------------------------------------------------
    //Table View Setting
    //---------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsMissed.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func toggleCells(){
        self.refreshControl?.beginRefreshing()
        //Do Refresh
        readMissingEvent()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        startDate = eventsMissed[indexPath.row].start
        self.performSegueWithIdentifier("seeDetail", sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: NSString = "cell"
        var cell: MGSwipeTableCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier as String) as! MGSwipeTableCell
        if(cell.isEqual(nil)){
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier as String)
        }
        cell.textLabel?.text = eventsMissed[indexPath.row].title
        var formatter = NSDateFormatter();
        formatter.dateFormat = "MMM dd, yyyy HH:MM"
        cell.detailTextLabel?.text = formatter.stringFromDate(eventsMissed[indexPath.row].start)
        cell.delegate = self; //optional
        cell.leftButtons = nil
        cell.rightButtons = rightButtonsArray()
        //configure left buttons
        //cell.leftSwipeSettings.transition = MGSwipeTransition.Rotate3D
        //configure right buttons
        //cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
        //println(eventsMissed.count)
        return cell
    }
}