//
//  FastView+Stack.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import DesignCore

public class QStack: UIStackView, ViewBuildable {
    var components: [ViewBuildable]
    var customConfiguration: ((UIStackView, [ViewBuildable]) -> Void)?

    @available(iOS, unavailable)
    public required init(coder: NSCoder) {
        fatalError("Unavailable")
    }

    public init(axis: NSLayoutConstraint.Axis, spacing: Double = 0,
                distribution: UIStackView.Distribution = .fillProportionally,
                @ViewBuilder _ components: () -> [ViewBuildable],
                customConfiguration: ((UIStackView, [ViewBuildable]) -> Void)? = nil) {
        self.components = components()
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        configureViews()
    }

    public func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate {
            widthAnchor.constraint(equalToConstant: 0).with(\.priority, setTo: .defaultLow)
            heightAnchor.constraint(equalToConstant: 0).with(\.priority, setTo: .defaultLow)
        }
        clipsToBounds = true
        components.forEach { addArrangedSubview($0.body) }
        customConfiguration?(self, components)
    }
}

public extension QStack {
    // swiftlint:disable:next type_name
    class Z: UIView, ViewBuildable {
        public var contents: [ViewBuildable]?
        public var insets: UIEdgeInsets = .zero
        public var customConfiguration: ((UIView, [ViewBuildable]) -> Void)?

        public required init(customConfiguration: ((UIView, [ViewBuildable]) -> Void)? = nil) {
            super.init(frame: .zero)
            self.customConfiguration = customConfiguration
        }

        public convenience init(insets: UIEdgeInsets = .zero,
                                @ViewBuilder _ content: () -> [ViewBuildable],
                                customConfiguration: ((UIView, [ViewBuildable]) -> Void)? = nil) {
            self.init(insets: insets, content(), customConfiguration: customConfiguration)
        }

        public convenience init(insets: UIEdgeInsets = .zero,
                                _ contents: [ViewBuildable],
                                customConfiguration: ((UIView, [ViewBuildable]) -> Void)? = nil) {
            self.init(customConfiguration: customConfiguration)
            self.contents = contents
            self.insets = insets
        }

        @available(iOS, unavailable)
        public required init?(coder: NSCoder) {
            fatalError("Unavailable")
        }

        public func configureViews() {
            translatesAutoresizingMaskIntoConstraints = false
            contents?.forEach {
                let content = $0.body
                addSubview(content)
                content.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate {
                    content.topAnchor.constraint(equalTo: topAnchor, constant: insets.top)
                    content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
                    content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left)
                    content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
                }
            }
            clipsToBounds = true
            customConfiguration?(self, contents ?? [])
        }
    }
}
