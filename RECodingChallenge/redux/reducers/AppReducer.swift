//
//  AppReducer.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        contentState: contentReducer(action: action, state: state?.contentState),
        playerState: playerReducer(action: action, state: state?.playerState)
    )
}
