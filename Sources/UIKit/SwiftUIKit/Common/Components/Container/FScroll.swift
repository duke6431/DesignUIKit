//
//  FScroll.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/12.
//
//  A customizable scroll view component that supports vertical or horizontal layout
//  of body components using fluent composition.
//

import UIKit
import DesignCore

/// A customizable scroll view component that supports arranging `FBodyComponent` views
/// either vertically or horizontally using declarative initialization and composition.
public final class FScroll: BaseScrollView, FComponent {
    /// The scroll direction of the content (horizontal or vertical).
    public var axis: NSLayoutConstraint.Axis
    /// The views to be arranged inside the scroll view.
    public var contentViews: [FBodyComponent] = []
    /// Optional closure for applying additional configuration to the scroll view.
    public var customConfiguration: ((FScroll) -> Void)?
    
    /// Initializes a scroll view with a single optional body component.
    /// - Parameters:
    ///   - axis: The scroll direction.
    ///   - contentView: A single content view to display.
    public init(
        axis: NSLayoutConstraint.Axis,
        contentView: FBodyComponent? = nil
    ) {
        self.axis = axis
        if let contentView {
            self.contentViews = [contentView]
        } else {
            self.contentViews = []
        }
        super.init(frame: .zero)
    }
    
    /// Initializes a scroll view with multiple body components using a builder.
    /// - Parameters:
    ///   - axis: The scroll direction.
    ///   - contentViews: A view builder closure that returns the scrollable content.
    public init(
        axis: NSLayoutConstraint.Axis,
        @FViewBuilder contentViews: () -> FBody
    ) {
        self.axis = axis
        self.contentViews = contentViews()
        super.init(frame: .zero)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        switch axis {
        case .horizontal:
            alwaysBounceHorizontal = true
        case .vertical:
            alwaysBounceVertical = true
        @unknown default:
            break
        }
        configuration?.didMoveToSuperview(superview, with: self)
        var top = topAnchor
        var leading = leadingAnchor
        contentViews.flatMap {
            ($0 as? FForEach)?.content() ?? [$0]
        }.forEach { view in
            addSubview(view.attachToParent(false))
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate {
                switch axis {
                case .horizontal:
                    view.topAnchor.constraint(equalTo: topAnchor)
                    view.bottomAnchor.constraint(equalTo: bottomAnchor)
                    view.leadingAnchor.constraint(equalTo: leading, constant: view.configuration?.containerPadding?.leading ?? 0)
                    view.centerYAnchor.constraint(equalTo: centerYAnchor)
                case .vertical:
                    view.topAnchor.constraint(equalTo: top, constant: view.configuration?.containerPadding?.top ?? 0)
                    view.leadingAnchor.constraint(equalTo: leadingAnchor)
                    view.trailingAnchor.constraint(equalTo: trailingAnchor)
                    view.centerXAnchor.constraint(equalTo: centerXAnchor)
                @unknown default:
                    view.topAnchor.constraint(equalTo: topAnchor, constant: view.configuration?.containerPadding?.top ?? 0)
                    view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(view.configuration?.containerPadding?.bottom ?? 0))
                    view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: view.configuration?.containerPadding?.leading ?? 0)
                    view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(view.configuration?.containerPadding?.trailing ?? 0))
                }
            }
            switch axis {
            case .horizontal:
                leading = view.trailingAnchor
            case .vertical:
                top = view.bottomAnchor
            @unknown default:
                break
            }
        }
        switch axis {
        case .horizontal:
            NSLayoutConstraint.activate {
                leading.constraint(equalTo: trailingAnchor)
            }
        case .vertical:
            NSLayoutConstraint.activate {
                top.constraint(equalTo: bottomAnchor)
            }
        @unknown default:
            break
        }
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
}
