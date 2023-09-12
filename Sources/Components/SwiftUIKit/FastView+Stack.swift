//
//  FastView+Stack.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import DesignCore

public extension FastView {
    struct Stack: FastViewable {
        var axis: NSLayoutConstraint.Axis
        var spacing: Double = 0
        var components: [FastViewable]
        var distribution: UIStackView.Distribution?
        var customConfiguration: ((UIStackView, [FastViewable]) -> Void)?

        public init(axis: NSLayoutConstraint.Axis, spacing: Double = 0,
                    distribution: UIStackView.Distribution? = nil,
                    @BuilderComponent<FastViewable> _ components: () -> [FastViewable],
                    customConfiguration: ((UIStackView, [FastViewable]) -> Void)? = nil) {
            self.axis = axis
            self.components = components()
            self.spacing = spacing
            self.distribution = distribution
            self.customConfiguration = customConfiguration
        }

        public init(axis: NSLayoutConstraint.Axis, spacing: Double = 0,
                    distribution: UIStackView.Distribution? = nil,
                    _ components: [FastViewable],
                    customConfiguration: ((UIStackView, [FastViewable]) -> Void)? = nil) {
            self.axis = axis
            self.components = components
            self.spacing = spacing
            self.distribution = distribution
            self.customConfiguration = customConfiguration
        }

        public func render() -> UIView {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate {
                view.widthAnchor.constraint(equalToConstant: 0).with(\.priority, setTo: .defaultLow)
                view.heightAnchor.constraint(equalToConstant: 0).with(\.priority, setTo: .defaultLow)
            }
            view.axis = axis
            if let distribution {
                view.distribution = distribution
            }
            view.spacing = CGFloat(spacing)
            view.clipsToBounds = true
            components.forEach { view.addArrangedSubview($0.render()) }
            customConfiguration?(view, components)
            return view
        }
    }

    struct ZStack: FastViewable {
        public var components: [FastViewable]
        public var customConfiguration: ((UIView, [FastViewable]) -> Void)?

        public init(@BuilderComponent<FastViewable> _ components: () -> [FastViewable],
                    customConfiguration: ((UIView, [FastViewable]) -> Void)? = nil) {
            self.components = components()
            self.customConfiguration = customConfiguration
        }

        public init(_ components: [FastViewable],
                    customConfiguration: ((UIView, [FastViewable]) -> Void)? = nil) {
            self.components = components
            self.customConfiguration = customConfiguration
        }

        public func render() -> UIView {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            components.map(\.rendered).forEach { component in
                view.addSubview(component)
                component.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate {
                    component.topAnchor.constraint(equalTo: view.topAnchor)
                    component.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                    component.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                    component.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                }
            }
            customConfiguration?(view, components)
            return view
        }
    }
}

func test() {
    FastView.Stack(axis: .vertical, spacing: 12) {
        Array(0...2).map { _ in
            FastView.ZStack {
                FastView.Stack(axis: .vertical) {
                    FastView(insets: .init(top: 12, left: 12, bottom: 12, right: 12)) {
                        FastView.Image(image: .init())
                    }
                    FastView.Label(text: "")
                }
                FastView.Button(text: "")
            }
        }
    }.rendered
}
