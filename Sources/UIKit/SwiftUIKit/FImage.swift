//
//  FImage.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import Nuke
import SnapKit

public class FImage: UIView, FViewable {
    public var image: UIImage?
    public var url: URL?
    public var size: CGSize = .zero
    public var contentHuggingV: UILayoutPriority = .defaultLow
    public var contentHuggingH: UILayoutPriority = .defaultLow
    public var compressionResistanceV: UILayoutPriority = .defaultHigh
    public var compressionResistanceH: UILayoutPriority = .defaultHigh
    
    public var shape: FShape?
    public var padding: UIEdgeInsets?
    public var customConfiguration: ((UIImageView, FImage) -> UIImageView)?
    
    public private(set) weak var content: UIImageView?
    
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
        self.contentHuggingV = contentHuggingV
        self.contentHuggingH = contentHuggingH
        self.compressionResistanceV = compressionResistanceV
        self.compressionResistanceH = compressionResistanceH
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
        self.contentMode = contentMode
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func rendered() -> UIImageView {
        var view = UIImageView(image: image)
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
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
    
    public override func didMoveToSuperview() {
        addSubview(rendered())
        snp.makeConstraints {
            $0.top.equalToSuperview().inset(padding?.top ?? 0).priority(.medium)
            $0.leading.equalToSuperview().inset(padding?.left ?? 0).priority(.medium)
            $0.trailing.equalToSuperview().inset(padding?.right ?? 0).priority(.medium)
            $0.bottom.equalToSuperview().inset(padding?.bottom ?? 0).priority(.medium)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        if let shape {
            UIView.animate(withDuration: 0.2) {
                switch shape {
                case .circle:
                    self.content?.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
                case .roundedRectangle(let cornerRadius, let corners):
                    self.content?.layer.masksToBounds = true
                    self.content?.layer.maskedCorners = corners.caMask
                    self.content?.layer.cornerRadius = min(cornerRadius, min(self.bounds.width, self.bounds.height)) / 2
                }
            }
        }
    }
}
