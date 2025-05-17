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

/// A lightweight video player component using `AVPlayerLayer`.
/// Supports local and remote video playback, autoplay, and looping.
public final class FVideoPlayer: UIView {
    /// An optional closure for applying additional configuration to the video player.
    public var customConfiguration: ((FVideoPlayer) -> Void)?
    
    /// The video URL to load and play. Can be local or remote.
    public var url: URL? {
        didSet {
            guard let url = url else { return }
            load(url: url)
        }
    }
    
    /// Whether the video should start playing automatically upon loading.
    public var autoplay: Bool = false
    
    /// Whether the video should loop back to the beginning after finishing.
    public var loop: Bool = false
    
    /// The internal `AVPlayer` responsible for playback.
    private var player: AVPlayer?
    
    /// The `AVPlayerLayer` used for rendering the video content.
    private var playerLayer: AVPlayerLayer?
    
    /// Initializes a new video player instance with a video URL.
    /// - Parameter url: The URL of the video to play.
    public init(url: URL? = nil) {
        super.init(frame: .zero)
        self.url = url
        if let url = url {
            load(url: url)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Loads a new video into the player and optionally starts playback.
    /// - Parameter url: The URL of the video to load.
    public func load(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playerLayer?.removeFromSuperlayer()
        playerLayer = AVPlayerLayer(player: player)
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
        if autoplay {
            play()
        }
        if loop {
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: playerItem)
        }
    }
    
    /// Starts video playback.
    public func play() {
        player?.play()
    }
    
    /// Pauses video playback.
    public func pause() {
        player?.pause()
    }
    
    /// Resets the playback to the beginning and pauses the player.
    public func reset() {
        player?.seek(to: .zero)
        pause()
    }
    
    /// Called when the video player is added to a superview. Triggers configuration and loading.
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        customConfiguration?(self)
        if let url = url {
            load(url: url)
        }
    }
    
    /// Updates the player layer's frame when the view layout changes.
    public override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    @objc private func playerDidFinishPlaying(notification: Notification) {
        if loop {
            reset()
            play()
        }
    }
    
    /// Cleans up the player and removes observers when the video player is deallocated.
    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
    }
}
