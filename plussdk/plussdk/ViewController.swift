//
//  ViewController.swift
//  plussdk
//
//  Created by Dong Li on 4/3/15.
//  Copyright (c) 2015 Dong Li. All rights reserved.
//

import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class ViewController: UIViewController, GPPSignInDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    var oldCoordinate: CGPoint?
    var oldHeight: CGFloat?
    var oldWidth: CGFloat?
    var topY: CGFloat?
    var bottomY: CGFloat?
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var signInButton: GPPSignInButton!
    var signIn: GPPSignIn?

    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabel2: UILabel!
    
    var time1: String = "0" {
        willSet(newSeconds) {
            println(newSeconds)
            self.timeLabel!.text = newSeconds
        }
    }
    var time2: String = "0" {
        willSet(newSeconds) {
            println(newSeconds)
            self.timeLabel2!.text = newSeconds
        }
    }

    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    @IBOutlet weak var moveTextView: UITextView!

    var items: [String] = ["111", "222", "333"]
    var showAddView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddView()
        moveTextView.selectable = false
        moveTextView.text = ""
        moveTextView.layer.borderWidth = 1
        moveTextView.layer.borderColor = UIColor.redColor().CGColor
        moveTextView.layer.cornerRadius = 5
        moveTextView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
        moveTextView.delegate = self
        moveTextView.frame = CGRectMake(10, 10, 100, 100)
        infoLabel.layer.borderWidth = 2
        self.timeTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        timeTableView.rowHeight = UITableViewAutomaticDimension
        timeTableView.estimatedRowHeight = 100

        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonPressed(sender: UIButton) {
        signIn = GPPSignIn.sharedInstance()
        
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.shouldFetchGoogleUserID = true
        signIn?.shouldFetchGoogleUserEmail = true
        signIn?.clientID = "717523156984-ds6jbi9b0ohsaejdln9adt6tn6fdkes9.apps.googleusercontent.com"
        signIn?.scopes = [kGTLAuthScopePlusLogin]
        signIn?.delegate = self
        signIn?.authenticate()
//        signIn?.trySilentAuthentication()
    }
    func finishedWithAuth(auth: GTMOAuth2Authentication?, error: NSError?) {
        infoLabel.text = auth?.userEmail
        print("login success \(auth?.userEmail)")
        println("\(signIn?.googlePlusUser.displayName)")
        var cc = signIn?.googlePlusUser.name.familyName
        println("\(cc)")
        println(error)
    }
    
    @IBAction func signOutButtonPressed(sender: UIButton) {
        signIn?.signOut()
        infoLabel.text = signIn?.userEmail
    }
    func didDisconnectWithError(error: NSError?) {
        
    }
    
    func setAddView() {
        
//        addView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png"))
        addView.hidden = true
        addView.layer.borderWidth = 2
        addView.layer.borderColor = UIColor.brownColor().CGColor
        addView.layer.cornerRadius = 5
        redButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
        greenButton.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.3)
        blueButton.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3)
    }
    
    @IBAction func addButtonAction(sender: AnyObject) {
        addView.hidden = showAddView
        showAddView = !showAddView
    }
    @IBAction func redButtonAction(sender: AnyObject) {
        moveTextView.backgroundColor = redButton.backgroundColor
        moveTextView.layer.borderColor = UIColor.redColor().CGColor
    }
    @IBAction func greenButtonAction(sender: AnyObject) {
        moveTextView.backgroundColor = greenButton.backgroundColor
        moveTextView.layer.borderColor = UIColor.greenColor().CGColor
    }
    @IBAction func blueButtonAction(sender: AnyObject) {
        moveTextView.backgroundColor = blueButton.backgroundColor
        moveTextView.layer.borderColor = UIColor.blueColor().CGColor
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            moveTextView.resignFirstResponder()
            moveTextView.selectable = false
            moveTextView.editable = false
            println("return pressed")
            moveTextView.frame = CGRectMake(oldCoordinate!.x, oldCoordinate!.y, oldWidth!, oldHeight!)
            return false
        }
        return true
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
        timeLabel.text = topY!.description
        timeLabel2.text = bottomY!.description
        println("x: \(topY) y: \(bottomY)")
        timeLabel.frame = CGRectMake(moveTextView.center.x + moveTextView.bounds.width/2, moveTextView.center.y - moveTextView.bounds.height/2, timeLabel.bounds.width, timeLabel.bounds.height)
        timeLabel2.frame = CGRectMake(moveTextView.center.x + moveTextView.bounds.width/2, moveTextView.center.y + moveTextView.bounds.height/2 - timeLabel2.bounds.height, timeLabel2.bounds.width, timeLabel2.bounds.height)

    }
//    @IBAction func handlePinchGesture(sender: AnyObject) {
//        
//        moveTextView.transform = CGAffineTransformScale(self.view.transform, 1.0, sender.scale)
//
//
//    }
    
    @IBAction func handleLongPressGesture(sender: AnyObject) {

        let location = sender.locationInView(self.view)
        moveTextView.center = location
        topY = moveTextView.frame.origin.y
        bottomY = topY! + moveTextView.bounds.height
        timeLabel.text = topY!.description
        timeLabel2.text = bottomY!.description
        timeLabel.frame = CGRectMake(location.x + moveTextView.bounds.width/2, location.y - moveTextView.bounds.height/2, timeLabel.bounds.width, timeLabel.bounds.height)
        timeLabel2.frame = CGRectMake(location.x + moveTextView.bounds.width/2, location.y + moveTextView.bounds.height/2 - timeLabel2.bounds.height, timeLabel2.bounds.width, timeLabel2.bounds.height)
        println("x: \(topY) y: \(bottomY)")
//                timeLabel.text = topY!.description

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        timeTableView.addSubview(cell)
        cell.textLabel?.text = "111"
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell \(indexPath.row)")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
}

