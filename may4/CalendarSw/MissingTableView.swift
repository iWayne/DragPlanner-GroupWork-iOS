//
//  MissingTableView.swift
//  ChronList
//
//  Created by Shan Shawn on 5/4/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import UIKit

class MissingTableView: UITableViewController,UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate, UIActionSheetDelegate {
    var eventsMissed:[MAEvent] = []
    
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
    

    func donedone(){
        println("Press Back")
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
            checkButtonAction(cell)
            break;
        case 1:
            listButtonAction(cell)
            break;
        case 2:
            crossButtonAction(cell)
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
    }
    
    func checkButtonAction(cell:MGSwipeTableCell){
        //Change the background of the Event event from Parse
        println("change BK")
    }
    
    func crossButtonAction(cell:MGSwipeTableCell){
        //Delete event from Parse
        println("Delete Event")
    }
    
    func listButtonAction(cell:MGSwipeTableCell){
        //Go to Timeline View
        println("Go to Timeline")
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: NSString = "cell"
        var cell: MGSwipeTableCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as MGSwipeTableCell
        if(cell.isEqual(nil)){
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        cell.textLabel?.text = eventsMissed[indexPath.row].title
        
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