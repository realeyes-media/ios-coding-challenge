//
//  TimeInterval+hms.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/14/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var hms: String {
        get {
            let hours = (self / 3600).withLeadingZero
            let minutes = (self.truncatingRemainder(dividingBy: 3600) / 60).withLeadingZero
            let seconds = self.truncatingRemainder(dividingBy: 60).withLeadingZero
            
            return hours != "00" ? "\(hours):\(minutes):\(seconds)" : "\(minutes):\(seconds)"
        }
    }
    
}
