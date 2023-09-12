//
//  FastView.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import SnapKit
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
                @BuilderComponent<FastViewable> _ content: () -> FastViewable,
                customConfiguration: ((UIView, FastViewable?) -> Void)? = nil) {
        self.content = content()
        self.insets = insets
        self.customConfiguration = customConfiguration
    }

    public func render() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let content = content?.rendered {
            view.addSubview(content)
            content.snp.makeConstraints {
                $0.top.equalToSuperview().offset(insets.top)
                $0.bottom.equalToSuperview().offset(-insets.bottom)
                $0.leading.equalToSuperview().offset(insets.left)
                $0.trailing.equalToSuperview().offset(-insets.right)
            }
        }
        view.clipsToBounds = true
        customConfiguration?(view, content)
        return view
    }
}
