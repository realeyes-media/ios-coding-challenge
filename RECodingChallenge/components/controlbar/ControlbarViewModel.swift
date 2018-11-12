//
//  ControlbarViewModel.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/14/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

class ControlbarViewModel: StoreSubscriber {
    
    let itemTitle = PublishSubject<String>()
    let playhead = PublishSubject<TimeInterval>()
    let duration = PublishSubject<TimeInterval>()
    let status = PublishSubject<PlayerStatus>()
    let fullscreen = PublishSubject<Bool>()
    
    init() {
        appStore.subscribe(self)
    }
    
    deinit {
        appStore.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        newPlayerState(state: state.playerState)
        newContentState(state: state.contentState)
    }
    
    func newPlayerState(state: PlayerState) {
        playhead.onNext(state.playhead)
        duration.onNext(state.duration)
        status.onNext(state.status)
        fullscreen.onNext(state.fullscreen)
    }
    
    func newContentState(state: ContentState) {
        guard let selectedItem = state.selectedItem else { return }
        itemTitle.onNext(selectedItem.title)
    }
    
}
