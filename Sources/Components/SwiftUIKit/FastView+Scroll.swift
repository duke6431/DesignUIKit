//
//  FastView+Scroll.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import DesignCore

public extension FastView {
    struct ScrollView: FastViewable {
        public var axis: NSLayoutConstraint.Axis
        public var content: FastViewable
        public var customConfiguration: ((UIScrollView, FastViewable) -> Void)?

        public init(axis: NSLayoutConstraint.Axis = .vertical,
                    @BuilderComponent<FastViewable> _ content: () -> FastViewable,
                    customConfiguration: ((UIScrollView, FastViewable) -> Void)? = nil) {
            self.axis = axis
            self.content = content()
            self.customConfiguration = customConfiguration
        }

        public func render() -> UIView {
            let view = UIScrollView()
            view.translatesAutoresizingMaskIntoConstraints = false
            let content = content.rendered
            view.addSubview(content)
            content.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate {
                content.topAnchor.constraint(equalTo: view.topAnchor)
                content.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                content.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                content.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            }
            NSLayoutConstraint.activate {
                switch axis {
                case .horizontal:
                    content.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                case .vertical:
                    content.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                @unknown default:
                    content.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                }
            }
            customConfiguration?(view, self.content)
            return view
        }
    }
}
