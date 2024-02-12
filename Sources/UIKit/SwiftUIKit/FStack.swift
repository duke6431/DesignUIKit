//
//  FStack.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public class FStack: FViewable {
    public var axis: NSLayoutConstraint.Axis
    public var arrangedSubviews: [AnyViewable]
    public var spacing: Double
    public var distribution: UIStackView.Distribution?
    public var customConfiguration: ((UIStackView, FStack) -> UIStackView)?
    
    public init(
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: Double = 0, 
        @FBuilder<AnyViewable> arrangedSubviews: () -> [AnyViewable],
        distribution: UIStackView.Distribution? = nil,
        customConfiguration: ((UIStackView, FStack) -> UIStackView)? = nil
    ) {
        self.axis = axis
        self.arrangedSubviews = arrangedSubviews()
        self.spacing = spacing
        self.distribution = distribution
        self.customConfiguration = customConfiguration
    }
    
    public func rendered() -> UIStackView {
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
        arrangedSubviews.forEach { view.addArrangedSubview($0.rendered()) }
        return customConfiguration?(view, self) ?? view
    }
}
