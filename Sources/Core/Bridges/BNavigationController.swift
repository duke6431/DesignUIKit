//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 3/21/24.
//

#if canImport(UIKit)
import UIKit

/// Unification of UINavigationController
public typealias BNavigationController = UINavigationController
#else
import AppKit

public class BNavigationController: BViewController {
    public private (set) var viewControllers: [BViewController] = []
    
    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
    }
    
    public init(rootViewController: BViewController) {
        super.init(nibName: nil, bundle: nil)
        pushViewController(rootViewController, animated: false)
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
}

extension BNavigationController {
    
    public var topViewController: BViewController? {
        return viewControllers.last
    }
    
    public func pushViewControllerAnimated(_ viewController: BViewController) {
        pushViewController(viewController, animated: true)
    }
    
    public func pushViewController(_ viewController: BViewController, animated: Bool) {
        viewController.navigationController = self
        viewController.view.wantsLayer = true
        if animated, let oldVC = topViewController {
            embbedChildViewController(viewController)
            let endFrame = oldVC.view.frame
            let startFrame = endFrame.offsetBy(dx: endFrame.width, dy: 0)
            viewController.view.frame = startFrame
            viewController.view.alphaValue = 0.85
            viewControllers.append(viewController)
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.2
                context.allowsImplicitAnimation = true
                context.timingFunction = CAMediaTimingFunction(name: .easeOut)
                viewController.view.animator().frame = endFrame
                viewController.view.animator().alphaValue = 1
                oldVC.view.animator().alphaValue = 0.25
            }) {
                oldVC.view.alphaValue = 1
                oldVC.view.removeFromSuperview()
            }
        } else {
            embbedChildViewController(viewController)
            viewControllers.append(viewController)
        }
    }
    
    @discardableResult
    public func popViewControllerAnimated() -> BViewController? {
        return popViewController(animated: true)
    }
    
    @discardableResult
    public func popViewController(animated: Bool) -> BViewController? {
        guard let oldVC = viewControllers.popLast() else {
            return nil
        }
        
        if animated, let newVC = topViewController {
            let endFrame = oldVC.view.frame.offsetBy(dx: oldVC.view.frame.width, dy: 0)
            view.addSubview(newVC.view, positioned: .below, relativeTo: oldVC.view)
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.23
                context.allowsImplicitAnimation = true
                context.timingFunction = CAMediaTimingFunction(name: .easeIn)
                oldVC.view.animator().frame = endFrame
                oldVC.view.animator().alphaValue = 0.85
            }) {
                self.unembbedChildViewController(oldVC)
            }
        } else {
            unembbedChildViewController(oldVC)
        }
        return oldVC
    }
}

extension BViewController {
    static let navigationController = ObjectAssociation<BNavigationController>()
    
    public var navigationController: BNavigationController? {
        get { return Self.navigationController[self] }
        set { Self.navigationController[self] = newValue }
    }
}

extension BViewController {
    
    public func embbedChildViewController(_ vc: BViewController, container: NSView? = nil) {
        addChild(vc)
        vc.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        vc.view.autoresizingMask = [.height, .width]
        (container ?? view).addSubview(vc.view)
    }
    
    public func unembbedChildViewController(_ vc: BViewController) {
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
#endif
