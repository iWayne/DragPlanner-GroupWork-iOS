//
//  Singleton.swift
//  BlackJack
//
//  Created by Shan Shawn on 3/2/15.
//  Copyright (c) 2015 Shan Shawn. All rights reserved.
//

import Foundation

class Singleton {
    var selectedDate:NSDate = NSDate()
    
    class var sharedInstance: Singleton {
        struct Static {
            static let instance: Singleton = Singleton()
        }
        return Static.instance
    }
}