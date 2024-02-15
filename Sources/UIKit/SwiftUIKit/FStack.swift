//
//  FStack.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public final class FStack: FBase<UIStackView>, FViewable {
    public class Configuration {
        public var axis: NSLayoutConstraint.Axis
        public var spacing: Double
        public var distribution: UIStackView.Distribution?
        
        init(
            axis: NSLayoutConstraint.Axis = .vertical,
            spacing: Double = 8,
            distribution: UIStackView.Distribution? = nil
        ) {
            self.axis = axis
            self.spacing = spacing
            self.distribution = distribution
        }
    }
    public var configuration: Configuration = .init()
    public var arrangedContents: [UIView]
    
    public var customConfiguration: ((UIStackView, FStack) -> UIStackView)?
    
    public init(
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: Double = 8,
        @FBuilder<UIView> arrangedContents: () -> [UIView],
        distribution: UIStackView.Distribution? = nil,
        customConfiguration: ((UIStackView, FStack) -> UIStackView)? = nil
    ) {
        self.arrangedContents = arrangedContents()
        self.configuration = .init(axis: axis, spacing: spacing, distribution: distribution)
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
    }

    @discardableResult
    public override func rendered() -> UIStackView {
        var view = UIStackView()
        view.snp.makeConstraints {
            $0.width.equalTo(0).priority(.low)
            $0.height.equalTo(0).priority(.low)
        }
        view.axis = configuration.axis
        if let distribution =  configuration.distribution {
            view.distribution = distribution
        }
        view.spacing = CGFloat(configuration.spacing)
        view.clipsToBounds = true
        arrangedContents.forEach {
            guard let content = $0 as? any FViewable else { return }
            let container = FView()
            if content.containerPadding ?? .zero != .zero {
                container.contentViews = [$0]
                container.shouldConstraintWithParent = false
                view.addArrangedSubview(container)
            } else {
                content.shouldConstraintWithParent = false
                view.addArrangedSubview($0)
            }
        }
        backgroundColor = contentBackgroundColor
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
}
