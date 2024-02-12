//
//  FStack.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public final class FStack: UIView, FViewable {
    public var axis: NSLayoutConstraint.Axis = .vertical
    public var arrangedContents: [AnyViewable]
    public var spacing: Double = 0
    public var distribution: UIStackView.Distribution?
    
    public var padding: UIEdgeInsets?
    public var customConfiguration: ((UIStackView, FStack) -> UIStackView)?
    
    public private(set) weak var content: UIStackView?
    
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
    public func rendered() -> UIStackView {
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
    
    public override func didMoveToSuperview() {
        addSubview(rendered())
        snp.makeConstraints {
            $0.top.equalToSuperview().inset(padding?.top ?? 0).priority(.medium)
            $0.leading.equalToSuperview().inset(padding?.left ?? 0).priority(.medium)
            $0.trailing.equalToSuperview().inset(padding?.right ?? 0).priority(.medium)
            $0.bottom.equalToSuperview().inset(padding?.bottom ?? 0).priority(.medium)
        }
    }
}
