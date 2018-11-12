//
//  AppStore.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift

let appStore = Store<AppState>(reducer: appReducer, state: nil)
