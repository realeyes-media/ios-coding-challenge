//
//  PlayerView.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/14/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift

protocol PlayerDelegate {
    func tapped()
    func complete()
}

class PlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var item: AVPlayerItem?
    var viewModel: PlayerViewModel?
    var timeObserver: Any?
    var delegate: PlayerDelegate?
    
    let disposeBag = DisposeBag()
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    func playItem(item: ContentItem) throws {
        guard let url = item.url else { throw PlayerError.invalidURL }
        
        viewModel = PlayerViewModel()
        
        viewModel?.updateStatus(status: .initialized)
        
        player = AVPlayer()
    
        let item = AVPlayerItem(url: url)
        self.item = item
        
        let options = viewModel?.options ?? PlayerOptions()
        
        player?.replaceCurrentItem(with: item)
        viewModel?.updateStatus(status: .ready)
        player?.playImmediately(atRate: options.autoPlay ? 1.0 : 0.0)
        
        addObservers()
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        removeObservers()
        player?.replaceCurrentItem(with: nil)
        item = nil
        player = nil
        viewModel = nil
    }
    
    func seek(toTime time: TimeInterval, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let duration = item?.duration.seconds else { return }
        var seekTime = max(0.0, time)
        seekTime = min(duration, seekTime)
        
        player?.seek(to: CMTime(seconds: seekTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), completionHandler: completion)
    }
    
    private func playheadUpdated(time: CMTime) {
        guard let item = item else { return }
        
        viewModel?.updatePlayhead(playhead: time.seconds)
        viewModel?.updateCurrentBuffer(buffer: item.currentBuffer)
        
        guard let lastEvent = item.accessLog()?.events.last else { return }
        
        let bitrate = lastEvent.indicatedBitrate
        
        if bitrate >= 0 {
            viewModel?.updateBitrate(bitrate: bitrate / 1000)
        }
    }
    
    private func addObservers() {
        guard let item = item, let player = player else { fatalError("Missing AVPlayer or AVPlayerItem") }
        
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: playheadUpdated)

        item.rx.observe(CMTime.self, "duration")
            .map { $0?.seconds ?? 0.0 }
            .subscribe(onNext: viewModel?.updateDuration)
            .disposed(by: disposeBag)

        player.rx.observe(Float.self, "rate")
            .subscribe(onNext: viewModel?.updatePlaybackRate)
            .disposed(by: disposeBag)
        
        player.rx.observe(AVPlayer.TimeControlStatus.self, "timeControlStatus")
            .subscribe(onNext: { [weak self] status in
                guard let status = status else { return }
            
                var playerStatus: PlayerStatus
                switch status {
                case AVPlayer.TimeControlStatus.playing:
                    playerStatus = .playing
                case AVPlayer.TimeControlStatus.paused:
                    playerStatus = .paused
                case AVPlayer.TimeControlStatus.waitingToPlayAtSpecifiedRate:
                    playerStatus = .buffering
                }
                
                self?.viewModel?.updateStatus(status: playerStatus)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.AVPlayerItemDidPlayToEndTime, object: item)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.updateStatus(status: .complete)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.AVPlayerItemFailedToPlayToEndTime, object: item)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.updateStatus(status: .errored)
            })
            .disposed(by: disposeBag)
    }
    
    private func removeObservers() {
        guard let timeObserver = timeObserver else { return }
        player?.removeTimeObserver(timeObserver)
    }

}
