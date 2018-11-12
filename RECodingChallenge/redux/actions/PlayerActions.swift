//
//  PlayerActions.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/14/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift

struct UpdateAssetURL: Action {
    let url: URL
}

struct UpdateStatus: Action {
    let status: PlayerStatus
}

struct UpdateBitrate: Action {
    let bitrate: Double
}

struct UpdateDuration: Action {
    let duration: TimeInterval
}

struct UpdatePlayhead: Action {
    let playhead: TimeInterval
}

struct UpdateFullscreen: Action {
    let fullscreen: Bool
}

struct UpdateBuffer: Action {
    let buffer: Double
}
