//
//  FastView+View.swift
//  DesignKit
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import DesignToolbox
import DesignCore

public class QLabel: UILabel, ViewBuildable {
    var customConfiguration: ((UILabel) -> Void)?

    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Unavailable")
    }

    public init(text: String = "", font: UIFont = FontSystem.font(with: .body),
                textColor: UIColor = .black,
                attributedText: NSAttributedString? = nil, numberOfLines: Int = 0,
                contentHuggingV: UILayoutPriority = .defaultLow,
                contentHuggingH: UILayoutPriority = .defaultLow,
                compressionResistanceV: UILayoutPriority = .defaultHigh,
                compressionResistanceH: UILayoutPriority = .defaultHigh,
                customConfiguration: ((UILabel) -> Void)? = nil) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        if let attributedText = attributedText {
            self.attributedText = attributedText
        }
        self.numberOfLines = numberOfLines
        self.setContentHuggingPriority(contentHuggingV, for: .vertical)
        self.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        self.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        self.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        self.customConfiguration = customConfiguration
        configureViews()
    }

    public func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        customConfiguration?(self)
    }
}

public class QImage: UIImageView, ViewBuildable {
    var url: URL?
    var size: CGSize = .zero
    var customConfiguration: ((UIImageView) -> Void)?

    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Unavailable")
    }
    public init(image: UIImage? = nil, url: URL? = nil, size: CGSize = .zero,
                contentMode: UIImageView.ContentMode = .scaleAspectFit,
                contentHuggingV: UILayoutPriority = .defaultLow,
                contentHuggingH: UILayoutPriority = .defaultLow,
                compressionResistanceV: UILayoutPriority = .defaultHigh,
                compressionResistanceH: UILayoutPriority = .defaultHigh,
                customConfiguration: ((UIImageView) -> Void)? = nil) {
        self.url = url
        self.size = size
        super.init(image: image)
        self.contentMode = contentMode
        self.setContentHuggingPriority(contentHuggingV, for: .vertical)
        self.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        self.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        self.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        self.customConfiguration = customConfiguration
        self.configureViews()
    }

    public func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        if size != .zero {
            NSLayoutConstraint.activate {
                widthAnchor.constraint(equalToConstant: size.width)
                heightAnchor.constraint(equalToConstant: size.height)
            }
        }
        customConfiguration?(self)
    }
}
