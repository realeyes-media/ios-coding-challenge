//
//  ContentItemDetailViewController.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import UIKit
import RxSwift

class ContentItemDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var controlbarContainerView: UIView!
    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var bufferLabel: UILabel!
    @IBOutlet weak var bitrateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playheadLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var viewModel: ContentItemDetailViewModel?
    var controlbarViewController: ControlbarViewController?
    var playerViewController: PlayerViewController?
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ContentItemDetailViewModel()
        
        addObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel = nil
        controlbarViewController = nil
        playerViewController = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controlbarViewController = segue.destination as? ControlbarViewController {
            controlbarViewController.delegate = self
            self.controlbarViewController = controlbarViewController
        }
        
        if let playerViewController = segue.destination as? PlayerViewController {
            self.playerViewController = playerViewController
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            playerViewController?.exitedFullscreen()
        } else {
            playerViewController?.enteredFullscreen()
        }
    }
    
    private func updateSelectedItem(_ item: ContentItem?) {
        titleLabel.text = item?.title
        sourceLabel.text = item?.source
    }
    
    private func addObservers() {
        guard let vm = viewModel else { fatalError("Missing view model") }
        
        let selectedItem$ = vm.selectedItem.asObservable().distinctUntilChanged()
        let playhead$ = vm.playhead.asObservable().distinctUntilChanged()
        let duration$ = vm.duration.asObservable().distinctUntilChanged()
        let bitrate$ = vm.bitrate.asObservable().distinctUntilChanged()
        let buffer$ = vm.buffer.asObservable().distinctUntilChanged()
        let status$ = vm.status.asObservable().distinctUntilChanged()
        
        selectedItem$
            .subscribe(onNext: updateSelectedItem)
            .disposed(by: disposeBag)

        playhead$
            .map { "Playhead: \($0)" }
            .bind(to: playheadLabel.rx.text)
            .disposed(by: disposeBag)
        
        duration$
            .map { "Duration: \($0)" }
            .bind(to: durationLabel.rx.text)
            .disposed(by: disposeBag)
        
        bitrate$
            .map { "Bitrate: \($0)" }
            .bind(to: bitrateLabel.rx.text)
            .disposed(by: disposeBag)
        
        buffer$
            .map { "Buffer: \($0)" }
            .bind(to: bufferLabel.rx.text)
            .disposed(by: disposeBag)
        
        status$
            .map { "Status: \($0.rawValue)" }
            .bind(to: statusLabel.rx.text)
            .disposed(by: disposeBag)
    }

}

extension ContentItemDetailViewController: ControlbarDelegate {
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func play() {
        playerViewController?.play()
    }
    
    func pause() {
        playerViewController?.pause()
    }
    
    func replayTen() {
        playerViewController?.replayTen()
    }
    
    func enterFullscreen() {
        DispatchQueue.main.async {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
        }
    }
    
    func exitFullscreen() {
        DispatchQueue.main.async {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    func seek(_ time: TimeInterval) {
        playerViewController?.seek(toTime: time, completion: { [weak self] _ in
            self?.playerViewController?.play()
        })
    }
    
}
