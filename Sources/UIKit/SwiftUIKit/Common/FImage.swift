//
//  FImage.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import Nuke
import SnapKit
import DesignCore

public class FImage: FBase<UIImageView>, FComponent, FContentContaining {
    public var image: UIImage?
    public var url: URL?
    
    public var contentHuggingV: UILayoutPriority = .defaultLow
    public var contentHuggingH: UILayoutPriority = .defaultLow
    public var compressionResistanceV: UILayoutPriority = .defaultHigh
    public var compressionResistanceH: UILayoutPriority = .defaultHigh
    
    public var customConfiguration: ((UIImageView, FImage) -> UIImageView)?
    
    public init(
        image: UIImage? = nil, url: URL? = nil
    ) {
        self.image = image
        self.url = url
        super.init(frame: .zero)
    }

    public convenience init(
        systemImage: String
    ) {
        self.init(
            image: .init(systemName: systemImage)
        )
    }
    
    public convenience init(
        named: String, in bundle: Bundle = .main
    ) {
        self.init(
            image: .init(named: named, in: bundle, with: nil)
        )
    }
    
    @discardableResult
    public override func rendered() -> UIImageView {
        var view = UIImageView(image: image)
        view.clipsToBounds = true
        view.contentMode = _contentMode
        view.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        view.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        view.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        view.setContentHuggingPriority(contentHuggingV, for: .vertical)
        if let url = url {
            ImagePipeline.shared.loadImage(with: url) { [weak self] result in
                if case .success(let response) = result, response.urlResponse?.url == self?.url {
                    
                    view.image = response.image
                }
            }
        }
        backgroundColor = contentBackgroundColor
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }

    public func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
}

public extension FImage {
    func reload(image: UIImage? = nil, url: URL?) {
        self.image = image ?? self.image
        self.url = url ?? self.url
        content?.image = image
        if let url = url {
            ImagePipeline.shared.loadImage(with: url) { [weak self] result in
                if case .success(let response) = result {
                    self?.content?.image = response.image
                }
            }
        }
    }
}
