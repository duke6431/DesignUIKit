//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit
import DesignCore

public final class FScroll: BaseScrollView, FComponent, FAssignable {
    public var axis: NSLayoutConstraint.Axis
    public var contentViews: [FBodyComponent] = []
    public var customConfiguration: ((FScroll) -> Void)?

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
