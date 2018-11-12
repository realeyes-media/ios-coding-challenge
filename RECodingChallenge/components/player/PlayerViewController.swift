//
//  PlayerViewController.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import UIKit
import RxSwift
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerView: PlayerView!
    
    var viewModel: PlayerViewModel?
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PlayerViewModel()
        
        addObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel = nil
        playerView.stop()
    }
    
    func play() {
        playerView.play()
    }
    
    func pause() {
        playerView.pause()
    }
    
    func seek(toTime time: TimeInterval, completion: @escaping (Bool) -> Void = { _ in }) {
        playerView.seek(toTime: time, completion: completion)
    }
    
    func replayTen() {
        let playerTime: TimeInterval = playerView.player?.currentTime().seconds ?? 0.0
        let seekTime = max(0.0, playerTime.advanced(by: -10.0))
        playerView.seek(toTime: seekTime)
    }
    
    func enteredFullscreen() {
        viewModel?.updateFullscreen(fullscreen: true)
    }
    
    func exitedFullscreen() {
        viewModel?.updateFullscreen(fullscreen: false)
    }
    
    private func initPlayer(item: ContentItem) {
        do {
            try playerView.playItem(item: item)
        } catch {
            print("Unable to play item...")
        }
    }
    
    private func addObservers() {
        guard let vm = viewModel else { fatalError("Missing view model") }
        
        vm.contentItem.asObservable()
            .distinctUntilChanged { $0.source == $1.source }
            .subscribe(onNext: initPlayer)
            .disposed(by: disposeBag)
    }

}
