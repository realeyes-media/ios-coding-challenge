//
//  ContentReducer.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/14/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift

func contentReducer(action: Action, state: ContentState?) -> ContentState {
    var state = state ?? ContentState()
    
    switch action {
    case let action as UpdateContentItems:
        state.items = action.items
    case let action as UpdateSelectedItem:
        state.selectedItem = action.item
    default:
        break
    }

    return state
}
