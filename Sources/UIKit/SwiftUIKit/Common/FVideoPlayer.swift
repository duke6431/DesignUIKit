//
//  VideoPlayer.swift
//  ZAV
//
//  Created by Duc Minh Nguyen on 2/27/24.
//

import Combine
import AVFoundation
import DesignCore
import DesignExts
import SnapKit

public class FVideoPlayer: BaseView, FComponent {
    public var layoutConfiguration: ((ConstraintMaker, BView) -> Void)?
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
        if let layoutConfiguration, let superview {
            snp.makeConstraints { make in
                layoutConfiguration(make, superview)
            }
        }
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
        playerLayer.backgroundColor = BColor.black.cgColor
        self.playerLayer = playerLayer
        playerLayer.frame = bounds
        #if canImport(UIKit)
        layer.addSublayer(playerLayer)
        #else
        layer?.addSublayer(playerLayer)
        #endif
    }
    
    func stop() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
    }
}
