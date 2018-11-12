//
//  PlayerReducer.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/14/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift

func playerReducer(action: Action, state: PlayerState?) -> PlayerState {
    var state = state ?? PlayerState()
    
    switch action {
    case let action as UpdateAssetURL:
        state.url = action.url
    case let action as UpdateStatus:
        state.status = action.status
    case let action as UpdateBitrate:
        state.bitrate = action.bitrate
    case let action as UpdateDuration:
        state.duration = action.duration
    case let action as UpdatePlayhead:
        state.playhead = action.playhead
    case let action as UpdateFullscreen:
        state.fullscreen = action.fullscreen
    case let action as UpdateBuffer:
        state.buffer = action.buffer
    default:
        break
    }
    
    return state
}
