//  ReadFromCalendar.swift
//  ChronList
//
//  Created by Shan Shawn on 4/30/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import Foundation
import EventKit

let bColor = UIColor(red:229/255, green:155/255, blue: 155/255, alpha: 0.7)
let rColor = UIColor(red:242/255, green:193/255, blue: 24/255, alpha: 0.7)
let gColor = UIColor(red:142/255, green:201/255, blue: 188/255, alpha: 0.7)

func showActoin(){
    println("show Action")
}
/*
func readFromAppleCalendar(oneDay:NSDate)->[MAEvent] {
    var store:EKEventStore = EKEventStore()
    var oneDayAgo:NSDate = NSDate().dateByAddingTimeInterval(-3600*24)
    var oneDayAfter: NSDate = NSDate().dateByAddingTimeInterval(3600*24)
    store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted:Bool, error) -> Void in
        if(granted){
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var predicate:NSPredicate = store.predicateForEventsWithStartDate(oneDayAgo, endDate: oneDayAfter, calendars: nil)
                if(store.eventsMatchingPredicate(predicate) != nil) {
                    var events:NSArray = store.eventsMatchingPredicate(predicate)
                    //clear Event Array
                    self.arr = []
                    for event in events {
                        //var oneEvent:EKEvent = event as EKEvent
                        //if(oneEvent.hasAlarms) {println("has alarm")}
                        //self.readEvent(oneEvent.startDate, endDate: oneEvent.endDate, title: oneEvent.title)
                        self.arr.append(assignEvent(event as EKEvent))
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
    //println("startDate: \(startDate.description)  endDate: \(endDate.description)  Title: \(title)")
    event.title = eventInput.title
    event.start = eventInput.startDate
    event.end = eventInput.endDate
    event.allDay = eventInput.allDay
    //if(eventInput.hasAlarms){}
    event.backgroundColor = gColor
    return event
}
*/