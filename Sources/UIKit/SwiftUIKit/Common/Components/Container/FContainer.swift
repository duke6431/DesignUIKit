//
//  FContainer.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 2024/10/20.
//
//  A generic container view that wraps a single content view with full edge constraints.
//  Supports additional configuration via a fluent-style API.
//

import UIKit

/// A generic container view that wraps a single content view constrained to all edges.
/// Provides a fluent API for configuring the content view.
public final class FContainer<View: UIView>: FView {
    /// The wrapped content view constrained to the edges of the container.
    public private(set) var content: View
    
    /// Initializes the container with a specific content view.
    /// - Parameter content: The view to embed inside the container.
    public init(content: View) {
        self.content = content
        super.init(frame: .zero)
    }
    
    /// Adds the content view to the container and pins it to all edges using SnapKit.
    public override func configureViews() {
        addSubview(content)
        content.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    /// Applies additional configuration to the embedded content view.
    /// - Parameter contentConfiguration: A closure used to modify the content view.
    /// - Returns: Self for chaining.
    public func configure(_ contentConfiguration: (View) -> Void) -> Self {
        contentConfiguration(content)
        return self
    }
}
