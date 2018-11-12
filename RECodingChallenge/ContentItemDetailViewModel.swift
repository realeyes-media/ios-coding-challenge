//
//  ContentItemDetailViewModel.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/12/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

class ContentItemDetailViewModel: StoreSubscriber {
    
    let selectedItem = BehaviorSubject<ContentItem?>(value: nil)
    let bitrate = PublishSubject<Double>()
    let playhead = PublishSubject<TimeInterval>()
    let duration = PublishSubject<TimeInterval>()
    let buffer = PublishSubject<Double>()
    let status = PublishSubject<PlayerStatus>()
    
    init() {
        appStore.subscribe(self)
    }
    
    deinit {
        appStore.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        newContentState(state: state.contentState)
        newPlayerState(state: state.playerState)
    }
    
    func newContentState(state: ContentState) {
        selectedItem.onNext(state.selectedItem)
    }
    
    func newPlayerState(state: PlayerState) {
        bitrate.onNext(state.bitrate)
        playhead.onNext(state.playhead)
        duration.onNext(state.duration)
        buffer.onNext(state.buffer)
        status.onNext(state.status)
    }
    
}
