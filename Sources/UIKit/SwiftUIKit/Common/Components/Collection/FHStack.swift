//
//  FHStack.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/20.
//
//  A horizontal stack view component built on top of `FStack`, defaulting to a horizontal axis.
//  Supports fluent configuration of spacing, distribution, and content via builder or direct array.
//

import UIKit
import DesignCore

/// A horizontal stack view component built on top of `FStack`, defaulting to a horizontal axis.
/// Allows flexible initialization using either a view builder or a direct body array.
public final class FHStack: FStack {
    /// Initializes a horizontal stack with body components from a view builder closure.
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
            axis: .horizontal, spacing: spacing,
            distribution: distribution, arrangedContents: arrangedContents
        )
    }
    
    /// Initializes a horizontal stack with a prebuilt array of body components.
    /// - Parameters:
    ///   - spacing: The spacing between arranged subviews.
    ///   - distribution: Optional stack distribution.
    ///   - arrangedContents: The array of components to arrange horizontally.
    public init(
        spacing: Double = 8,
        distribution: UIStackView.Distribution? = nil,
        arrangedContents: FBody
    ) {
        super.init(
            axis: .horizontal, spacing: spacing,
            distribution: distribution, arrangedContents: arrangedContents
        )
    }
}
