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
    else if colorCode == "UIDeviceRGBColorSpace 0.862745 1 0.823529 0.7" {
        return finishColor
    }
    else {
        return gColor
    }
}