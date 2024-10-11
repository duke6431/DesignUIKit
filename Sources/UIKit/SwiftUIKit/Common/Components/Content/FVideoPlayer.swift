//
//  VideoPlayer.swift
//  ZAV
//
//  Created by Duc Minh Nguyen on 2/27/24.
//

import UIKit
import AVFoundation
import DesignCore
import DesignExts

public final class FVideoPlayer: BaseView, FComponent, FAssignable {
    public var customConfiguration: ((FVideoPlayer) -> Void)?

    fileprivate weak var player: AVPlayer?
    fileprivate weak var playerLayer: AVPlayerLayer?
    
    public init(with player: AVPlayer) {
        super.init(frame: .zero)
        self.player = player
        load()
    }
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
        playerLayer?.frame = bounds
        playerLayer?.setNeedsLayout()
        playerLayer?.layoutIfNeeded()
    }
    
    deinit { stop() }
}

public extension FVideoPlayer {
    func load() {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.backgroundColor = UIColor.black.cgColor
        self.playerLayer = playerLayer
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
    }
    
    func stop() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
    }
}
