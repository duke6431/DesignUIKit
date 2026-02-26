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

/// `FVideoPlayer` is a reusable view for rendering video content using `AVPlayerLayer`.
///
/// Usage:
/// ```swift
/// let player = AVPlayer(url: url)
/// let videoView = FVideoPlayer(with: player)
/// videoView.contentMode(.resizeAspectFill)
/// ```
///
/// The view manages an internal `AVPlayerLayer` and keeps it sized to its bounds.
/// Call `stop()` to pause playback and remove the layer when the view is no longer needed.
public final class FVideoPlayer: BaseView, FComponent {
    /// Optional hook to perform additional configuration when the view moves to a superview.
    /// This closure is invoked from `didMoveToSuperview()` after the `configuration` hook.
    public var customConfiguration: ((FVideoPlayer) -> Void)?

    /// The player responsible for providing media to the layer.
    /// Weak to avoid retain cycles with external owners managing the player.
    fileprivate weak var player: AVPlayer?
    /// The backing layer that renders the video content.
    /// Weak because the view's layer hierarchy retains it.
    fileprivate weak var playerLayer: AVPlayerLayer?

    /// Initializes the video player view with an existing `AVPlayer`.
    /// - Parameter player: The player that will provide media for playback.
    /// The view immediately prepares its `AVPlayerLayer` by calling `load()`.
    public init(with player: AVPlayer) {
        super.init(frame: .zero)
        self.player = player
        load()
    }
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // Invoke framework configuration first, then custom configuration.
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }

    /// Ensures the `AVPlayerLayer` tracks the view's bounds and remains transparent.
    /// Also forwards a layout update to any attached configuration.
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
        // Keep the video layer composited over transparent backgrounds.
        playerLayer?.isOpaque = false
        playerLayer?.backgroundColor = UIColor.clear.cgColor
        playerLayer?.frame = bounds
        playerLayer?.setNeedsLayout()
        playerLayer?.layoutIfNeeded()
    }

    /// Sets the video gravity (content mode) of the underlying `AVPlayerLayer`.
    /// - Parameter contentMode: One of the `AVLayerVideoGravity` values, e.g. `.resizeAspect`.
    /// - Returns: Self, to allow chaining.
    public func contentMode(_ contentMode: AVLayerVideoGravity) -> Self {
        playerLayer?.videoGravity = contentMode
        return self
    }

    // Ensure playback is paused and the layer is removed when the view is deallocated.
    deinit { stop() }
}

public extension FVideoPlayer {
    /// Creates and attaches an `AVPlayerLayer` to the view's layer hierarchy.
    /// Call this after setting/updating the `player` if needed.
    func load() {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.backgroundColor = UIColor.black.cgColor
        self.playerLayer = playerLayer
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
    }

    /// Pauses playback and removes the `AVPlayerLayer` from the view.
    /// Safe to call multiple times.
    func stop() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
    }
}

