//
//  Double+format.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/14/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation

extension Double {
    
    var withLeadingZero: String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        
        return formatter.string(from: NSNumber(value: self)) ?? "00"
    }
    
}
