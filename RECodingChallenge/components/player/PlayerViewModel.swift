//
//  PlayerViewModel.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/14/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

let playerOptions = PlayerOptions()

class PlayerViewModel: StoreSubscriber {
    
    let contentItem = PublishSubject<ContentItem>()
    let options = playerOptions

    init() {
        appStore.subscribe(self)
    }
    
    deinit {
        appStore.unsubscribe(self)
    }
    
    func updateStatus(status: PlayerStatus) {
        appStore.dispatch(UpdateStatus(status: status))
    }
    
    func updatePlayhead(playhead: TimeInterval) {
        appStore.dispatch(UpdatePlayhead(playhead: playhead))
    }
    
    func updateDuration(duration: TimeInterval) {
        guard !duration.isNaN else { return }
        appStore.dispatch(UpdateDuration(duration: duration))
    }
    
    func updateBitrate(bitrate: Double) {
        appStore.dispatch(UpdateBitrate(bitrate: bitrate))
    }
    
    func updatePlaybackRate(rate: Float?) {
        guard let rate = rate else { return }
        
        if rate == 0.0 {
            appStore.dispatch(UpdateStatus(status: .paused))
        } else {
            appStore.dispatch(UpdateStatus(status: .playing))
        }
    }
    
    func updateFullscreen(fullscreen: Bool) {
        appStore.dispatch(UpdateFullscreen(fullscreen: fullscreen))
    }
    
    func updateCurrentBuffer(buffer: Double) {
        appStore.dispatch(UpdateBuffer(buffer: buffer))
    }
    
    func newState(state: AppState) {
        newContentState(state: state.contentState)
    }
    
    private func newContentState(state: ContentState) {
        if let selectedItem = state.selectedItem {
            contentItem.onNext(selectedItem)
        }
    }
    
}
