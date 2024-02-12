//
//  FImage.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import Nuke

public class FImage: FViewable {
    public var image: UIImage?
    public var url: URL?
    public var size: CGSize
    public var contentMode: UIImageView.ContentMode
    public var contentHuggingV: UILayoutPriority
    public var contentHuggingH: UILayoutPriority
    public var compressionResistanceV: UILayoutPriority
    public var compressionResistanceH: UILayoutPriority
    public var customConfiguration: ((UIImageView, FImage) -> UIImageView)?
    
    public init(
        image: UIImage? = nil, url: URL? = nil,
        size: CGSize = .zero, contentMode: UIImageView.ContentMode = .scaleAspectFit,
        contentHuggingV: UILayoutPriority = .defaultLow, contentHuggingH: UILayoutPriority = .defaultLow,
        compressionResistanceV: UILayoutPriority = .defaultHigh, compressionResistanceH: UILayoutPriority = .defaultHigh,
        customConfiguration: ((UIImageView, FImage) -> UIImageView)? = nil
    ) {
        self.image = image
        self.url = url
        self.size = size
        self.contentMode = contentMode
        self.contentHuggingV = contentHuggingV
        self.contentHuggingH = contentHuggingH
        self.compressionResistanceV = compressionResistanceV
        self.compressionResistanceH = compressionResistanceH
        self.customConfiguration = customConfiguration
    }
    
    public func rendered() -> UIImageView {
        let view = UIImageView(image: image)
        view.contentMode = contentMode
        view.clipsToBounds = true
        view.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        view.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        view.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        view.setContentHuggingPriority(contentHuggingV, for: .vertical)
        if let url = url {
            ImagePipeline.shared.loadImage(with: url) { result in
                if case .success(let response) = result {
                    view.image = response.image
                }
            }
        }
        view.snp.makeConstraints {
            if size.width > 0 { $0.width.equalTo(size.width).priority(.medium) }
            if size.height > 0 { $0.height.equalTo(size.height).priority(.medium) }
        }
        return customConfiguration?(view, self) ?? view
    }
}
