//
//  ContentSelectorViewModel.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

let itemsJson: [[String: String]] = [
    [
        "title": "Big Buck Bunny",
        "source": "https://video-dev.github.io/streams/x36xhzz/x36xhzz.m3u8"
    ]
]

class ContentSelectorViewModel: StoreSubscriber {
    
    let contentItems = PublishSubject<[ContentItem]>()
    let selectedItem = PublishSubject<ContentItem?>()
    
    init() {
        appStore.subscribe(self) { sub in sub.select { state in state.contentState } }
    }
    
    deinit {
        appStore.unsubscribe(self)
    }
    
    func getItems() {
        let items: [ContentItem] = itemsJson.map { ContentItem(json: $0) }
        appStore.dispatch(UpdateContentItems(items: items))
    }
    
    func updateSelectedItem(item: ContentItem?) {
        appStore.dispatch(UpdateSelectedItem(item: item))
    }
    
    func newState(state: ContentState) {
        contentItems.onNext(state.items)
        selectedItem.onNext(state.selectedItem)
    }
    
}
