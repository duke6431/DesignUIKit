//
//  FImage.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import Nuke
import SnapKit

public class FImage: FBase<UIImageView>, FComponent {
    public var image: UIImage?
    public var url: URL?
    public var size: CGSize = .zero
    public var contentHuggingV: UILayoutPriority = .defaultLow
    public var contentHuggingH: UILayoutPriority = .defaultLow
    public var compressionResistanceV: UILayoutPriority = .defaultHigh
    public var compressionResistanceH: UILayoutPriority = .defaultHigh
    
    public var customConfiguration: ((UIImageView, FImage) -> UIImageView)?
    
    public init(
        image: UIImage? = nil, url: URL? = nil,
        size: CGSize = .zero, contentMode: UIImageView.ContentMode = .scaleAspectFit,
        contentHuggingV: UILayoutPriority = .defaultLow, contentHuggingH: UILayoutPriority = .defaultLow,
        compressionResistanceV: UILayoutPriority = .defaultHigh, compressionResistanceH: UILayoutPriority = .defaultHigh
    ) {
        self.image = image
        self.url = url
        self.size = size
        self.contentHuggingV = contentHuggingV
        self.contentHuggingH = contentHuggingH
        self.compressionResistanceV = compressionResistanceV
        self.compressionResistanceH = compressionResistanceH
        super.init(frame: .zero)
        self.contentMode = contentMode
    }

    public convenience init(
        systemImage: String, size: CGSize = .zero, contentMode: UIImageView.ContentMode = .scaleAspectFit,
        contentHuggingV: UILayoutPriority = .defaultLow, contentHuggingH: UILayoutPriority = .defaultLow,
        compressionResistanceV: UILayoutPriority = .defaultHigh, compressionResistanceH: UILayoutPriority = .defaultHigh
    ) {
        self.init(
            image: .init(systemName: systemImage), size: size, contentMode: contentMode,
            contentHuggingV: contentHuggingV, contentHuggingH: contentHuggingH,
            compressionResistanceV: compressionResistanceV, compressionResistanceH: compressionResistanceH
        )
    }
    
    public convenience init(
        named: String, in bundle: Bundle = .main, size: CGSize = .zero, contentMode: UIImageView.ContentMode = .scaleAspectFit,
        contentHuggingV: UILayoutPriority = .defaultLow, contentHuggingH: UILayoutPriority = .defaultLow,
        compressionResistanceV: UILayoutPriority = .defaultHigh, compressionResistanceH: UILayoutPriority = .defaultHigh
    ) {
        self.init(
            image: .init(named: named, in: bundle, with: nil), size: size, contentMode: contentMode,
            contentHuggingV: contentHuggingV, contentHuggingH: contentHuggingH,
            compressionResistanceV: compressionResistanceV, compressionResistanceH: compressionResistanceH
        )
    }
    
    @discardableResult
    public override func rendered() -> UIImageView {
        var view = UIImageView(image: image)
        view.clipsToBounds = true
        view.contentMode = contentMode
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
            if size.width > 0 { $0.width.equalTo(size.width) }
            if size.height > 0 { $0.height.equalTo(size.height) }
        }
        backgroundColor = contentBackgroundColor
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
}

public extension FImage {
    func reload(image: UIImage? = nil, url: URL?) {
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
