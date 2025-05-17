//
//  FVStack.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/20.
//
//  A vertical stack view component that wraps `FStack` with a fixed vertical axis.
//  Supports fluent configuration of spacing, distribution, and content via builder or direct array.
//

import UIKit
import DesignCore

/// A vertical stack view component built on top of `FStack`, defaulting to a vertical axis.
/// Allows flexible initialization using either a view builder or a direct body array.
public final class FVStack: FStack {
    /// Initializes a vertical stack with body components from a view builder closure.
    /// - Parameters:
    ///   - spacing: The spacing between arranged subviews.
    ///   - distribution: Optional stack distribution.
    ///   - arrangedContents: A builder closure returning an array of body components.
    public init(
        spacing: Double = 8,
        distribution: UIStackView.Distribution? = nil,
        @FViewBuilder arrangedContents: () -> FBody
    ) {
        super.init(
            axis: .vertical, spacing: spacing,
            distribution: distribution, arrangedContents: arrangedContents
        )
    }
    
    /// Initializes a vertical stack with a prebuilt array of body components.
    /// - Parameters:
    ///   - spacing: The spacing between arranged subviews.
    ///   - distribution: Optional stack distribution.
    ///   - arrangedContents: The array of components to arrange vertically.
    public init(
        spacing: Double = 8,
        distribution: UIStackView.Distribution? = nil,
        arrangedContents: FBody
    ) {
        super.init(
            axis: .vertical, spacing: spacing,
            distribution: distribution, arrangedContents: arrangedContents
        )
    }
}
