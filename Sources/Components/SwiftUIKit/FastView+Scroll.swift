//
//  FastView+Scroll.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import SnapKit
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
            content.snp.makeConstraints {
                $0.edges.equalToSuperview()
                switch axis {
                case .horizontal:
                    $0.centerY.equalToSuperview()
                case .vertical:
                    $0.centerX.equalToSuperview()
                @unknown default:
                    $0.centerX.equalToSuperview()
                }
            }
            customConfiguration?(view, self.content)
            return view
        }
    }
}
