//
//  ControlbarViewController.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import UIKit
import RxSwift

protocol ControlbarDelegate {
    func dismiss()
    func play()
    func pause()
    func replayTen()
    func enterFullscreen()
    func exitFullscreen()
    func seek(_ time: TimeInterval)
}

class ControlbarViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playheadSlider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var enterExitFullscreenButton: UIButton!
    
    @IBAction func playPauseButtonAction(_ sender: Any) {
        if playing {
            delegate?.pause()
        } else {
            delegate?.play()
        }
    }
    
    @IBAction func replayTenButtonAction(_ sender: Any) {
        delegate?.replayTen()    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        delegate?.dismiss()
    }
    
    @IBAction func enterExitFullscreenAction(_ sender: Any) {
        if fullscreen {
            delegate?.exitFullscreen()
        } else {
            delegate?.enterFullscreen()
        }
    }
    
    @IBAction func sliderTouchDownAction(_ sender: Any) {
        delegate?.pause()
    }
    
    @IBAction func sliderTouchUpInsideAction(_ sender: Any) {
        let position = playheadSlider.value
        delegate?.seek(Double(position) * duration)
    }
    
    @IBAction func sliderTouchUpOutsideAction(_ sender: Any) {
        delegate?.play()
    }
    
    var viewModel: ControlbarViewModel?
    var delegate: ControlbarDelegate?
    
    var playing = false
    var fullscreen = false
    var duration = 0.0
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ControlbarViewModel()
        
        addObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel = nil
    }
    
    private func addObservers() {
        guard let vm = viewModel else { fatalError("Missing viewModel") }
        
        vm.itemTitle.asObservable()
            .distinctUntilChanged({ $0 == $1 })
            .bind(to: backButton.rx.title())
            .disposed(by: disposeBag)
        
        vm.status.asObservable()
            .distinctUntilChanged()
            .map { [weak self] status in
                guard let bundle = Bundle(identifier: kBundleIdentifier) else { throw ControlbarError.missingBundle }
                
                let playing = status == .playing
                self?.playing = playing
                
                let imageName = !playing ? AssetNames.playButtonName : AssetNames.pauseButtonName
                guard let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) else { throw ControlbarError.missingAsset }
                
                return image
            }
            .bind(to: playPauseButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        vm.fullscreen.asObservable()
            .distinctUntilChanged({ $0 == $1 })
            .map { [weak self] fullscreen in
                guard let bundle = Bundle(identifier: kBundleIdentifier) else { throw ControlbarError.missingBundle }
                
                self?.fullscreen = fullscreen
                
                let imageName = !fullscreen ? AssetNames.enterFullscreenButtonName : AssetNames.exitFullscreenButtonName
                
                guard let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) else { throw ControlbarError.missingAsset }
                
                return image
            }
            .bind(to: enterExitFullscreenButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        let duration$ = vm.duration.asObservable().distinctUntilChanged({ $0 == $1 })
        let playhead$ = vm.playhead.asObservable().distinctUntilChanged({ $0 == $1 })
        
        let progress$ = Observable.combineLatest(duration$, playhead$)
            
        duration$
            .map { $0.hms }
            .bind(to: durationLabel.rx.text)
            .disposed(by: disposeBag)
        
        progress$
            .subscribe(onNext: { [weak self] (duration, playhead) in
                self?.duration = duration
                self?.playheadSlider.value = Float(playhead / duration)
            })
            .disposed(by: disposeBag)
    }

}
