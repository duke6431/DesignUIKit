//
//  FastView.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import DesignToolbox
import DesignCore

public protocol FastViewable {
    var rendered: UIView { get }
    func render() -> UIView
}

public extension FastViewable {
    var rendered: UIView { render() }
}

public struct FastView: FastViewable {
    public var content: FastViewable?
    public var insets: UIEdgeInsets = .zero
    public var customConfiguration: ((UIView, FastViewable?) -> Void)?

    public init(customConfiguration: ((UIView, FastViewable?) -> Void)? = nil) {
        self.customConfiguration = customConfiguration
    }

    public init(insets: UIEdgeInsets = .zero,
                @BuilderComponent<FastViewable> _ content: () -> [FastViewable],
                customConfiguration: ((UIView, FastViewable?) -> Void)? = nil) {
        self.content = content().first
        self.insets = insets
        self.customConfiguration = customConfiguration
    }

    public init(insets: UIEdgeInsets = .zero,
                _ content: FastViewable,
                customConfiguration: ((UIView, FastViewable?) -> Void)? = nil) {
        self.content = content
        self.insets = insets
        self.customConfiguration = customConfiguration
    }

    public func render() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let content = content?.rendered {
            view.addSubview(content)
            content.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate {
                content.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top)
                content.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
                content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left)
                content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)
            }
        }
        view.clipsToBounds = true
        customConfiguration?(view, content)
        return view
    }
}
