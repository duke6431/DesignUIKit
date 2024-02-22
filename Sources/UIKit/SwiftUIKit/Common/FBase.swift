//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 12/02/2024.
//

import UIKit
import SnapKit
import DesignCore
import DesignExts

public class FBase<Content: UIView>: BaseView {
    public var contentBackgroundColor: UIColor = .clear
    public var shape: FShape?
    public var shadow: CALayer.ShadowConfiguration?
    
    public var ratio: CGFloat?
    public var containerPadding: UIEdgeInsets?
    public var contentInsets: UIEdgeInsets?
    public var width: CGFloat?
    public var height: CGFloat?
    public var opacity: CGFloat = 1

    public var shouldConstraintWithParent: Bool = true
    public weak var content: Content?
    
    public override func didMoveToSuperview() {
        addSubview(rendered())
        alpha = opacity
        if shouldConstraintWithParent, superview != nil {
            snp.makeConstraints {
                $0.top.equalToSuperview().inset(containerPadding?.top ?? 0)
                $0.leading.equalToSuperview().inset(containerPadding?.left ?? 0)
                $0.trailing.equalToSuperview().inset(containerPadding?.right ?? 0)
                $0.bottom.equalToSuperview().inset(containerPadding?.bottom ?? 0)
            }
        }
        content?.snp.makeConstraints {
            $0.top.equalToSuperview().inset(contentInsets?.top ?? 0).priority(.high.advanced(by: 50))
            $0.leading.equalToSuperview().inset(contentInsets?.left ?? 0).priority(.high.advanced(by: 50))
            $0.trailing.equalToSuperview().inset(contentInsets?.right ?? 0).priority(.high.advanced(by: 50))
            $0.bottom.equalToSuperview().inset(contentInsets?.bottom ?? 0).priority(.high.advanced(by: 50))
            if let ratio, let content { $0.width.equalTo(content.snp.height).multipliedBy(ratio) }
            if let width { $0.width.equalTo(width) }
            if let height { $0.height.equalTo(height) }
        }
    }
    
    public func rendered() -> Content {
        fatalError("FBase - rendered must be overridden")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    func updateLayers() {
        if let shape {
            clipsToBounds = true
            UIView.animate(withDuration: 0.2) {
                switch shape {
                case .circle:
                    self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
                case .roundedRectangle(let cornerRadius, let corners):
                    self.layer.maskedCorners = corners.caMask
                    self.layer.cornerRadius = min(cornerRadius, min(self.bounds.width, self.bounds.height) / 2)
                }
            }
        }
        if let shadow {
            UIView.animate(withDuration: 0.2) {
                self.layer.add(
                    shadow: shadow.updated(
                        \.path, with: UIBezierPath(rect: self.bounds).cgPath
                    )
                )
            }
        }
    }
    
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        self.width = width
        self.height = height
        return self
    }
}

public class FViewControllerBase<Content: UIViewController>: BaseView {
    public var contentBackgroundColor: UIColor = .clear
    public var shape: FShape?
    public var shadow: CALayer.ShadowConfiguration?
    
    public var ratio: CGFloat?
    public var containerPadding: UIEdgeInsets?
    public var contentInsets: UIEdgeInsets?
    public var width: CGFloat?
    public var height: CGFloat?
    public var opacity: CGFloat = 1

    public var shouldConstraintWithParent: Bool = true
    public weak var parentViewController: UIViewController?
    public weak var content: Content?
    
    public override func didMoveToSuperview() {
        let controller = rendered()
        guard let parentViewController else { return }
        controller.willMove(toParent: parentViewController)
        addSubview(controller.view)
        parentViewController.addChild(controller)
        controller.didMove(toParent: parentViewController)
        alpha = opacity
        if shouldConstraintWithParent, superview != nil {
            snp.makeConstraints {
                $0.top.equalToSuperview().inset(containerPadding?.top ?? 0)
                $0.leading.equalToSuperview().inset(containerPadding?.left ?? 0)
                $0.trailing.equalToSuperview().inset(containerPadding?.right ?? 0)
                $0.bottom.equalToSuperview().inset(containerPadding?.bottom ?? 0)
            }
        }
        content?.view.snp.makeConstraints {
            $0.top.equalToSuperview().inset(contentInsets?.top ?? 0).priority(.high.advanced(by: 50))
            $0.leading.equalToSuperview().inset(contentInsets?.left ?? 0).priority(.high.advanced(by: 50))
            $0.trailing.equalToSuperview().inset(contentInsets?.right ?? 0).priority(.high.advanced(by: 50))
            $0.bottom.equalToSuperview().inset(contentInsets?.bottom ?? 0).priority(.high.advanced(by: 50))
            if let ratio, let content { $0.width.equalTo(content.view.snp.height).multipliedBy(ratio) }
            if let width { $0.width.equalTo(width) }
            if let height { $0.height.equalTo(height) }
        }
    }
    
    public func rendered() -> Content {
        fatalError("FBase - rendered must be overridden")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    func updateLayers() {
        if let shape {
            clipsToBounds = true
            UIView.animate(withDuration: 0.2) {
                switch shape {
                case .circle:
                    self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
                case .roundedRectangle(let cornerRadius, let corners):
                    self.layer.maskedCorners = corners.caMask
                    self.layer.cornerRadius = min(cornerRadius, min(self.bounds.width, self.bounds.height) / 2)
                }
            }
        }
        if let shadow {
            UIView.animate(withDuration: 0.2) {
                self.layer.add(
                    shadow: shadow.updated(
                        \.path, with: UIBezierPath(rect: self.bounds).cgPath
                    )
                )
            }
        }
    }
    
    public func parent(_ viewController: UIViewController) -> Self {
        parentViewController = viewController
        return self
    }
    
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        self.width = width
        self.height = height
        return self
    }
}

public class FScrollBase<Content: UIView>: BaseScrollView {
    public var contentBackgroundColor: UIColor = .clear
    public var shape: FShape?
    public var shadow: CALayer.ShadowConfiguration?
    
    public var containerPadding: UIEdgeInsets?
    public var contentInsets: UIEdgeInsets?
    public var width: CGFloat?
    public var height: CGFloat?
    
    public var shouldConstraintWithParent: Bool = true
    public weak var content: Content?
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(rendered())
        if shouldConstraintWithParent, superview != nil {
            snp.makeConstraints {
                $0.top.equalToSuperview().inset(containerPadding?.top ?? 0)
                $0.leading.equalToSuperview().inset(containerPadding?.left ?? 0)
                $0.trailing.equalToSuperview().inset(containerPadding?.right ?? 0)
                $0.bottom.equalToSuperview().inset(containerPadding?.bottom ?? 0)
            }
        }
        content?.snp.makeConstraints {
            $0.top.equalToSuperview().inset(contentInsets?.top ?? 0).priority(.high.advanced(by: 50))
            $0.leading.equalToSuperview().inset(contentInsets?.left ?? 0).priority(.high.advanced(by: 50))
            $0.trailing.equalToSuperview().inset(contentInsets?.right ?? 0).priority(.high.advanced(by: 50))
            $0.bottom.equalToSuperview().inset(contentInsets?.bottom ?? 0).priority(.high.advanced(by: 50))
            if let width { $0.width.equalTo(width) }
            if let height { $0.height.equalTo(height) }
        }
    }
    
    public func rendered() -> Content {
        fatalError("FBase - rendered must be overridden")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    func updateLayers() {
        if let shape {
            clipsToBounds = true
            UIView.animate(withDuration: 0.2) {
                switch shape {
                case .circle:
                    self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
                case .roundedRectangle(let cornerRadius, let corners):
                    self.layer.maskedCorners = corners.caMask
                    self.layer.cornerRadius = min(cornerRadius, min(self.bounds.width, self.bounds.height) / 2)
                }
            }
        }
        if let shadow {
            UIView.animate(withDuration: 0.2) {
                self.layer.add(
                    shadow: shadow.updated(
                        \.path, with: UIBezierPath(rect: self.bounds).cgPath
                    )
                )
            }
        }
    }
    
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        self.width = width
        self.height = height
        return self
    }
}
