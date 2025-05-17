//
//  PanelAnimationController.swift
//  Duke Nguyen
//
//  Created by Duke Nguyen on 14/06/2022.
//

import UIKit
import DesignCore

extension PanModal {
    class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
        private static var presentDuration: TimeInterval = 0.3
        private static var dismissDuration: TimeInterval = 0.25
        private let usingSpring: Bool
        private let direction: OriginDirection

        init(direction: OriginDirection = .bottom, usingSpring: Bool = false) {
            self.direction = direction
            self.usingSpring = usingSpring
            super.init()
        }

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            let fromView = transitionContext?.viewController(forKey: .from)
            return fromView != nil ? AnimationController.presentDuration : AnimationController.dismissDuration
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let fromViewController = transitionContext.viewController(forKey: .from),
                  let fromView = transitionContext.view(forKey: .from) ?? fromViewController.view,
                  let toViewController = transitionContext.viewController(forKey: .to),
                  let toView = transitionContext.view(forKey: .to) ?? toViewController.view else {
                return
            }

            let toPresentingViewController = toViewController.presentingViewController
            let presenting = toPresentingViewController == fromViewController

            let containerView = transitionContext.containerView
            if presenting {
                containerView.addSubview(toView)
            }

            let animatingView = presenting ? toView: fromView

            animatingView.frame = frame(presenting: presenting, for: direction, of: animatingView, in: containerView)
            let finalFrame = frame(presenting: !presenting, for: direction, of: animatingView, in: containerView)
            var springFrame = finalFrame
            springFrame.size.height += 20
            springFrame.origin.y -= 10
            let transitionDuration = self.transitionDuration(using: transitionContext)

            UIView.animateKeyframes(
                withDuration: transitionDuration, delay: 0,
                options: .calculationModeCubic,
                animations: { [weak self] in
                    if presenting && self?.usingSpring ?? false {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75) {
                            animatingView.frame = finalFrame
                        }
                        UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.125) {
                            animatingView.frame = springFrame
                        }
                        UIView.addKeyframe(withRelativeStartTime: 0.875, relativeDuration: 0.125) {
                            animatingView.frame = finalFrame
                        }
                    } else {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                            animatingView.frame = finalFrame
                        }
                    }
                },
                completion: { _ in
                    if !presenting, !transitionContext.transitionWasCancelled {
                        fromView.removeFromSuperview()
                    }
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            )
        }

        func frame(presenting: Bool, for direction: OriginDirection,
                   of targetView: UIView, in containerView: UIView) -> CGRect {
            switch direction {
            case .bottom:
                return .init(
                    x: 0,
                    y: presenting
                    ? containerView.bounds.height
                    : containerView.bounds.height - targetView.bounds.height,
                    width: targetView.bounds.width,
                    height: targetView.bounds.height
                )
            case .top:
                return .init(
                    x: 0,
                    y: presenting ? -targetView.bounds.height : 0,
                    width: targetView.bounds.width,
                    height: targetView.bounds.height
                )
            }
        }
    }
}
