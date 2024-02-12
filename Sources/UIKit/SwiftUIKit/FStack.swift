//
//  FStack.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public final class FStack: FBase<UIStackView>, FViewable {
    public var axis: NSLayoutConstraint.Axis = .vertical
    public var arrangedContents: [AnyViewable]
    public var spacing: Double = 0
    public var distribution: UIStackView.Distribution?
    
    public var customConfiguration: ((UIStackView, FStack) -> UIStackView)?
    
    public init(
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: Double = 0, 
        @FBuilder<AnyViewable> arrangedContents: () -> [AnyViewable],
        distribution: UIStackView.Distribution? = nil,
        customConfiguration: ((UIStackView, FStack) -> UIStackView)? = nil
    ) {
        self.axis = axis
        self.arrangedContents = arrangedContents()
        self.spacing = spacing
        self.distribution = distribution
        self.customConfiguration = customConfiguration
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        self.arrangedContents = []
        super.init(coder: coder)
    }
    
    @discardableResult
    public override func rendered() -> UIStackView {
        var view = UIStackView()
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
        arrangedContents.forEach { view.addArrangedSubview($0.rendered()) }
        view = customConfiguration?(view, self) ?? view
        content = view
        return view
    }
}
