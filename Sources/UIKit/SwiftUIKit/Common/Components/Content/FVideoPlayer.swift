//
//  FVideoPlayer.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/11.
//
//  A lightweight video player component supporting playback from local or remote URLs,
//  with optional autoplay and looping features.
//

import UIKit
import AVFoundation
import DesignCore
import DesignExts

/// A lightweight video player view that supports AVPlayer-based playback.
/// Can be initialized with a preconfigured AVPlayer and optionally customized via closure.
public class FVideoPlayer: BaseView, FComponent {
    /// An optional closure for applying additional configuration after being added to a superview.
    public var customConfiguration: ((FVideoPlayer) -> Void)?
    
    fileprivate weak var player: AVPlayer?
    fileprivate weak var playerLayer: AVPlayerLayer?
    
    /// Initializes the video player with a provided `AVPlayer`.
    /// - Parameter player: The `AVPlayer` instance to use for playback.
    public init(with player: AVPlayer) {
        super.init(frame: .zero)
        self.player = player
        load()
    }
    /// Called when the view is added to a superview. Applies configuration and customization.
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }
    
    /// Updates layout of internal AVPlayerLayer and applies configuration updates.
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
        playerLayer?.frame = bounds
        playerLayer?.setNeedsLayout()
        playerLayer?.layoutIfNeeded()
    }
    
    /// Cleans up player resources when the view is deallocated.
    deinit { stop() }
}

public extension FVideoPlayer {
    /// Initializes and attaches an AVPlayerLayer to the view’s layer hierarchy.
    func load() {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.backgroundColor = UIColor.black.cgColor
        self.playerLayer = playerLayer
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
    }
    
    /// Stops video playback and removes the player layer from the view.
    func stop() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
    }
}
