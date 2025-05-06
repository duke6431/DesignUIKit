//
//  FImage.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import Nuke
import DesignCore

public class FImage: BaseImageView, FThemableForeground, FComponent, FContentConstraintable {
    public var url: URL?

    public var customConfiguration: ((FImage) -> Void)?

    public init(
        image: UIImage? = nil, url: URL? = nil
    ) {
        self.url = url
        super.init(image: image)
    }

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

    public convenience init(
        named: String, in bundle: Bundle = .main
    ) {
        self.init(image: .init(named: named, in: bundle, with: nil))
    }

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

    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }

    @discardableResult public func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }

    @discardableResult public func foreground(_ color: UIColor) -> Self {
        currentForegroundColor = color
        image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        return self
    }

    public private(set) var currentForegroundColor: UIColor?
    public var foregroundKey: ThemeKey?
    public override func apply(theme: ThemeProvider) {
        super.apply(theme: theme)
        guard let foregroundKey else { return }
        foreground(theme.color(key: foregroundKey))
    }
}

public extension FImage {
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
