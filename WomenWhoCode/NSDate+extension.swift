//
//  NSDate+extension.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

extension NSDate {
    var day: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(self)
        
    }
    var month: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.stringFromDate(self)
    }
    var hour0x: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh"
        return dateFormatter.stringFromDate(self)
    }
    var minute0x: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.stringFromDate(self)
    }
}
