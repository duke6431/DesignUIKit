//
//  FImage.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/11.
//
//  A customizable image view component that supports theme integration,
//  remote image loading via Nuke, and fluent configuration.
//

import UIKit
import Nuke
import DesignCore

/// A customizable image view component that supports theming and asynchronous remote loading.
/// Provides convenient initializers and modifiers for fluent UI setup.
public final class FImage: BaseImageView, FThemableForeground, FComponent, FContentConstraintable {
    /// The URL used to asynchronously load an image using Nuke.
    public var url: URL?
    
    /// An optional closure used for additional runtime configuration.
    public var customConfiguration: ((FImage) -> Void)?
    
    /// Initializes the image view with an optional local image and optional remote URL.
    public init(
        image: UIImage? = nil, url: URL? = nil
    ) {
        self.url = url
        super.init(image: image)
    }
    
    /// Initializes the image view with a system symbol image and optional configuration.
    public convenience init(
        systemImage: String, configuration: UIImage.SymbolConfiguration? = nil
    ) {
        var image: UIImage?
        image = .init(systemName: systemImage)
        if let configuration {
            image = image?.withConfiguration(configuration)
        }
        self.init(image: image)
    }
    
    /// Initializes the image view using an image from the specified bundle.
    public convenience init(
        named: String, in bundle: Bundle = .main
    ) {
        self.init(image: .init(named: named, in: bundle, with: nil))
    }
    
    /// Called when the image view is added to a superview. Triggers configuration and remote loading if needed.
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        reload(image: image, url: url)
        if let url = url {
            image = nil
            ImagePipeline.shared.loadImage(with: url) { [weak self] result in
                if case .success(let response) = result {
                    self?.image = response.image
                }
            }
        }
        customConfiguration?(self)
    }
    
    /// Updates layers when the view layout changes.
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    /// Sets the content mode for the image view.
    /// - Parameter contentMode: The desired content mode.
    /// - Returns: Self for chaining.
    @discardableResult public func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    /// Applies a tint color to the image using `.alwaysOriginal` rendering.
    /// - Parameter color: The tint color to apply.
    /// - Returns: Self for chaining.
    @discardableResult public func foreground(_ color: UIColor) -> Self {
        currentForegroundColor = color
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return self
    }
    
    /// Holds the currently applied foreground color, used for re-tinting.
    private var currentForegroundColor: UIColor?
    public var foregroundKey: ThemeKey?
    /// Applies the theme-based foreground tint using a registered theme key.
    public override func apply(theme: ThemeProvider) {
        super.apply(theme: theme)
        guard let foregroundKey else { return }
        foreground(theme.color(key: foregroundKey))
    }
}

public extension FImage {
    /// Reloads the image from a new source, optionally applying a tint if set.
    /// - Parameters:
    ///   - image: A new local image to display.
    ///   - url: An optional new URL to load the image from.
    func reload(image: UIImage? = nil, url: URL? = nil) {
        self.image = image
        if let currentForegroundColor {
            self.image = self.image?.withTintColor(currentForegroundColor, renderingMode: .alwaysOriginal)
        }
        self.url = url ?? self.url
        guard let url else { return }
        ImagePipeline.shared.loadImage(with: url) { [weak self] result in
            if case .success(let response) = result, self?.url == response.request.url {
                self?.image = response.image
            }
        }
    }
}
