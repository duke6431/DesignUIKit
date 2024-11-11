//
//  FStack.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import DesignCore

public class FStack: BaseStackView, FComponent {
    public var customConfiguration: ((FStack) -> Void)?

    var arrangedContents: FBody

    public init(
        axis: NSLayoutConstraint.Axis,
        spacing: Double = 8,
        distribution: UIStackView.Distribution? = nil,
        @FViewBuilder arrangedContents: () -> FBody
    ) {
        self.arrangedContents = arrangedContents()
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution ?? .fill
    }

    public init(
        axis: NSLayoutConstraint.Axis,
        spacing: Double = 8,
        distribution: UIStackView.Distribution? = nil,
        arrangedContents: FBody
    ) {
        self.arrangedContents = arrangedContents
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution ?? .fill
    }

    func addContents(_ body: FBody) {
        body.flatMap {
            ($0 as? FForEach)?.content() ?? [$0]
        }.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview($0)
        }
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addContents(arrangedContents)
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
}
