//
//  FastView+View.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import SnapKit
import DesignToolbox
import DesignCore

public extension FastView {
    struct Label : FastViewable {
        var text: String = ""
        var font: UIFont = FontSystem.font(with: .body)
        var color: UIColor = .black
        var attributedText: NSAttributedString? = nil
        var numberOfLine: Int = 0
        var contentHuggingV: UILayoutPriority = .defaultLow
        var contentHuggingH: UILayoutPriority = .defaultLow
        var compressionResistanceV: UILayoutPriority = .defaultHigh
        var compressionResistanceH: UILayoutPriority = .defaultHigh
        var customConfiguration: ((UILabel) -> Void)? = nil
        
        public init(text: String, font: UIFont, color: UIColor,
                    attributedText: NSAttributedString? = nil, numberOfLine: Int,
                    contentHuggingV: UILayoutPriority, contentHuggingH: UILayoutPriority,
                    compressionResistanceV: UILayoutPriority, compressionResistanceH: UILayoutPriority,
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
        var image: UIImage? = nil
        var url: URL? = nil
        var size: CGSize = .zero
        var contentMode: UIImageView.ContentMode = .scaleAspectFit
        var contentHuggingV: UILayoutPriority = .defaultLow
        var contentHuggingH: UILayoutPriority = .defaultLow
        var compressionResistanceV: UILayoutPriority = .defaultHigh
        var compressionResistanceH: UILayoutPriority = .defaultHigh
        var customConfiguration: ((UIImageView) -> Void)?
        
        public init(image: UIImage? = nil, url: URL? = nil, size: CGSize,
                    contentMode: UIImageView.ContentMode,
                    contentHuggingV: UILayoutPriority, contentHuggingH: UILayoutPriority,
                    compressionResistanceV: UILayoutPriority, compressionResistanceH: UILayoutPriority,
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
            view.snp.makeConstraints {
                if size.width > 0 { $0.width.equalTo(size.width).priority(.medium) }
                if size.height > 0 { $0.height.equalTo(size.height).priority(.medium) }
            }
            customConfiguration?(view)
            return view
        }
    }
}
