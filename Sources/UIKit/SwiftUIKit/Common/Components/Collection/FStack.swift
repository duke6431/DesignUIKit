//
//  FStack.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/11.
//
//  A flexible stack view component built on top of `UIStackView` that supports
//  declarative configuration of body components with vertical or horizontal layout.
//

import UIKit
import DesignCore

/// A flexible stack view component supporting vertical or horizontal layout.
/// Accepts an array of body components or a view builder closure for layout composition.
public class FStack: BaseStackView, FComponent {
    /// Optional closure for performing additional custom runtime configuration.
    public var customConfiguration: ((FStack) -> Void)?
    
    /// The list of components to be arranged in the stack view.
    public var arrangedContents: FBody
    
    /// Initializes a stack view with a view builder closure to generate arranged content.
    /// - Parameters:
    ///   - axis: The stack layout direction (horizontal or vertical).
    ///   - spacing: The spacing between arranged views.
    ///   - distribution: Optional stack distribution configuration.
    ///   - arrangedContents: A closure that returns the array of views to arrange.
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
    
    /// Initializes a stack view with an existing array of arranged body components.
    /// - Parameters:
    ///   - axis: The stack layout direction (horizontal or vertical).
    ///   - spacing: The spacing between arranged views.
    ///   - distribution: Optional stack distribution configuration.
    ///   - arrangedContents: An array of views to arrange.
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
    
    /// Adds the given body components to the stack view, flattening any `FForEach` components.
    /// - Parameter body: The array of views or wrappers to insert into the stack.
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
        configuration?.didMoveToSuperview(superview, with: self)
        addContents(arrangedContents)
        customConfiguration?(self)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
}
