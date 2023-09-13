//
//  FastView+View.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import DesignToolbox
import DesignCore

public extension FastView {
    struct Label: FastViewable {
        var text: String = ""
        var font: UIFont = FontSystem.font(with: .body)
        var color: UIColor = .black
        var attributedText: NSAttributedString?
        var numberOfLine: Int = 0
        var contentHuggingV: UILayoutPriority = .defaultLow
        var contentHuggingH: UILayoutPriority = .defaultLow
        var compressionResistanceV: UILayoutPriority = .defaultHigh
        var compressionResistanceH: UILayoutPriority = .defaultHigh
        var customConfiguration: ((UILabel) -> Void)?

        public init(text: String = "", font: UIFont = FontSystem.font(with: .body), color: UIColor = .black,
                    attributedText: NSAttributedString? = nil, numberOfLine: Int = 0,
                    contentHuggingV: UILayoutPriority = .defaultLow,
                    contentHuggingH: UILayoutPriority = .defaultLow,
                    compressionResistanceV: UILayoutPriority = .defaultHigh,
                    compressionResistanceH: UILayoutPriority = .defaultHigh,
                    customConfiguration: ((UILabel) -> Void)? = nil) {
            self.text = text
            self.font = font
            self.color = color
            self.attributedText = attributedText
            self.numberOfLine = numberOfLine
            self.contentHuggingV = contentHuggingV
            self.contentHuggingH = contentHuggingH
            self.compressionResistanceV = compressionResistanceV
            self.compressionResistanceH = compressionResistanceH
            self.customConfiguration = customConfiguration
        }

        public func render() -> UIView {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.text = text
            view.font = font
            if let attributedText = attributedText {
                view.attributedText = attributedText
            }
            view.clipsToBounds = true
            view.textColor = color
            view.numberOfLines = numberOfLine
            view.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
            view.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
            view.setContentHuggingPriority(contentHuggingH, for: .horizontal)
            view.setContentHuggingPriority(contentHuggingV, for: .vertical)
            customConfiguration?(view)
            return view
        }
    }

    struct Image: FastViewable {
        var image: UIImage?
        var url: URL?
        var size: CGSize = .zero
        var contentMode: UIImageView.ContentMode = .scaleAspectFit
        var contentHuggingV: UILayoutPriority = .defaultLow
        var contentHuggingH: UILayoutPriority = .defaultLow
        var compressionResistanceV: UILayoutPriority = .defaultHigh
        var compressionResistanceH: UILayoutPriority = .defaultHigh
        var customConfiguration: ((UIImageView) -> Void)?

        public init(image: UIImage? = nil, url: URL? = nil, size: CGSize = .zero,
                    contentMode: UIImageView.ContentMode = .scaleAspectFit,
                    contentHuggingV: UILayoutPriority = .defaultLow,
                    contentHuggingH: UILayoutPriority = .defaultLow,
                    compressionResistanceV: UILayoutPriority = .defaultHigh,
                    compressionResistanceH: UILayoutPriority = .defaultHigh,
                    customConfiguration: ((UIImageView) -> Void)? = nil) {
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

        public func render() -> UIView {
            let view = UIImageView(image: image)
            view.contentMode = contentMode
            view.clipsToBounds = true
            view.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
            view.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
            view.setContentHuggingPriority(contentHuggingH, for: .horizontal)
            view.setContentHuggingPriority(contentHuggingV, for: .vertical)
            view.translatesAutoresizingMaskIntoConstraints = true
            if size != .zero {
                NSLayoutConstraint.activate {
                    view.widthAnchor.constraint(equalToConstant: size.width)
//                        .with(\.priority, setTo: .init(rawValue: 500))
                    view.heightAnchor.constraint(equalToConstant: size.height)
//                        .with(\.priority, setTo: .init(rawValue: 500))
                }
            }
            customConfiguration?(view)
            return view
        }
    }
}
