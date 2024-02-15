//
//  PanelTransitioningDelegate.swift
//  Duc Nguyen
//
//  Created by Duc IT. Nguyen Minh on 15/06/2022.
//

import UIKit

extension PanModal {
    class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
        private var animationController: AnimationController
        private var interactionController: InteractionController
        private let dimmingView: UIView?
        private var direction: OriginDirection = .bottom
        private var interactive: Bool = true

        init(dimmingView: UIView? = nil, direction: OriginDirection = .bottom, interactive: Bool = true) {
            self.dimmingView = dimmingView
            self.direction = direction
            self.animationController = .init(direction: direction)
            self.interactionController = .init(direction: direction)
            self.interactive = interactive
        }

        func presentationController(forPresented presented: UIViewController,
                                    presenting: UIViewController?,
                                    source: UIViewController) -> UIPresentationController? {
            let presentationController = PanelPresentationController(
                presentedViewController: presented, presenting: presenting,
                direction: direction, with: dimmingView
            )
            interactionController.wireToViewController(viewController: presented, interactive: interactive)
            if let dimmingView = dimmingView {
                interactionController.wireToView(view: dimmingView, interactive: interactive)
            }
            return presentationController
        }

        func animationController(forPresented presented: UIViewController,
                                 presenting: UIViewController,
                                 source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return animationController
        }

        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return animationController
        }

        func interactionControllerForDismissal(
            using animator: UIViewControllerAnimatedTransitioning
        ) -> UIViewControllerInteractiveTransitioning? {
            if interactionController.interactionInProgress {
                return interactionController
            }
            return nil
        }
    }
}
