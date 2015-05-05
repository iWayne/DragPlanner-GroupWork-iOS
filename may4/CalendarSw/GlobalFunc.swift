//
//  GlobalFunc.swift
//  CalendarSw
//
//  Created by Shan Shawn on 5/4/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import Foundation

func getMidnight(newDate:NSDate)->NSDate{
    var calendar:NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
    var comp:NSDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: newDate)
    return calendar.dateFromComponents(comp)!
}