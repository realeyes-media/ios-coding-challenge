//
//  AVPlayerItem+buffer.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 11/1/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayerItem {
    
    public var totalBuffer: Double {
        get {
            return self.loadedTimeRanges
                .map({ $0.timeRangeValue })
                .reduce(0.0, { acc, cur in
                    return acc + CMTimeGetSeconds(cur.start) + CMTimeGetSeconds(cur.duration)
                })
        }
    }
    
    public var currentBuffer: Double {
        get {
            let currentTime = self.currentTime()
            
            guard let timeRange = self.loadedTimeRanges.map({ $0.timeRangeValue })
                .first(where: { $0.containsTime(currentTime) }) else { return 0.0 }
            
            return CMTimeGetSeconds(timeRange.end) - currentTime.seconds
        }
    }
    
}
