//
//  ContentActions.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift

struct UpdateContentItems: Action {
    let items: [ContentItem]
}

struct UpdateSelectedItem: Action {
    let item: ContentItem?
}
