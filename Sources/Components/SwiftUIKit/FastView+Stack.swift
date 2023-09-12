//
//  FastView+Stack.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import SnapKit
import DesignCore

public extension FastView {
    struct Stack: FastViewable {
        var axis: NSLayoutConstraint.Axis
        var spacing: Double = 0
        var components: [FastViewable]
        var distribution: UIStackView.Distribution?
        var customConfiguration: ((UIStackView, [FastViewable]) -> Void)?
        
        public init(axis: NSLayoutConstraint.Axis, spacing: Double = 0, distribution: UIStackView.Distribution? = nil, @BuilderComponent<[FastViewable]> _ components: () -> [FastViewable], customConfiguration: ((UIStackView, [FastViewable]) -> Void)? = nil) {
            self.axis = axis
            self.components = components()
            self.spacing = spacing
            self.distribution = distribution
            self.customConfiguration = customConfiguration
        }
        
        public func render() -> UIView {
            let view = UIStackView()
            view.snp.makeConstraints {
                $0.width.equalTo(0).priority(.low)
                $0.height.equalTo(0).priority(.low)
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
        var components: [FastViewable]
        var customConfiguration: ((UIView, [FastViewable]) -> Void)? = nil
        
        public init(@BuilderComponent<[FastViewable]> _ components: () -> [FastViewable], customConfiguration: ((UIView, [FastViewable]) -> Void)? = nil) {
            self.components = components()
            self.customConfiguration = customConfiguration
        }
        
        public func render() -> UIView {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            components.map(\.rendered).forEach {
                view.addSubview($0)
                $0.snp.makeConstraints { $0.edges.equalToSuperview() }
            }
            customConfiguration?(view, components)
            return view
        }
    }
}
