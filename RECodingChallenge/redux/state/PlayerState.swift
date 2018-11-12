//
//  PlayerState.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/14/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation

struct PlayerState {
    var url: URL?
    var bitrate: Double = 0.0
    var playhead: TimeInterval = 0.0
    var duration: TimeInterval = 0.0
    var status: PlayerStatus = .uninitialized
    var fullscreen: Bool = false
    var buffer: Double = 0.0
}
