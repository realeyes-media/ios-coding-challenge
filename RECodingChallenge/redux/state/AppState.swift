//
//  AppState.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var contentState: ContentState
    var playerState: PlayerState
}
