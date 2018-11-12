//
//  PlayerStatus.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/14/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation

enum PlayerStatus: String {
    case uninitialized
    case initialized
    case ready
    case paused
    case playing
    case buffering
    case complete
    case errored
}
