//
//  PanelPresentationController.swift
//  Duc Nguyen
//
//  Created by Duc IT. Nguyen Minh on 14/06/2022.
//

import UIKit
import DesignCore

protocol DimmingViewProtocol {
    func animateDimming(_ alpha: CGFloat)
    func update(bottomConstantFromTop: CGFloat)
}

extension PanModal {
    class PanelPresentationController: UIPresentationController {
        private var dimmingView: UIView!
        private var direction: OriginDirection

        override var frameOfPresentedViewInContainerView: CGRect {
            guard let containerView = containerView else { return .zero }
            let presentedViewSize = size(forChildContentContainer: presentedViewController,
                                         withParentContainerSize: containerView.bounds.size)
            return CGRect(
                x: 0,
                y: [
                    OriginDirection.top: 0,
                    OriginDirection.bottom: containerView.bounds.height - presentedViewSize.height
                ][direction] ?? 0,
                width: presentedViewSize.width,
                height: presentedViewSize.height
            )
        }

        init(presentedViewController: UIViewController,
             presenting presentingViewController: UIViewController?,
             direction: OriginDirection, with dimmingView: UIView?) {
            self.direction = direction
            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
            setupDimming(view: dimmingView)
        }

        // MARK: Private

        private func setupDimming(view: UIView? = nil) {
            if let view = view {
                dimmingView = view
            } else {
                dimmingView = UIView().with(\.backgroundColor, setTo: UIColor(white: 0, alpha: 0.4))
            }
            if let dimmingView = dimmingView as? DimmingViewProtocol {
                dimmingView.animateDimming(0)
            } else {
                dimmingView.alpha = 0
            }
        }

        override func presentationTransitionWillBegin() {
            guard let containerView = containerView, let presentedView = presentedView else { return }

            dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            dimmingView.frame = containerView.bounds
            containerView.insertSubview(dimmingView, at: 0)
            if let dimmingView = dimmingView as? DimmingViewProtocol {
                dimmingView.update(
                    bottomConstantFromTop: containerView.bounds.height - frameOfPresentedViewInContainerView.height
                )
            }
            presentedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            presentedView.frame = frameOfPresentedViewInContainerView

            containerView.layoutIfNeeded()

            animateDimmingView(to: 1)
        }

        override func dismissalTransitionWillBegin() {
            animateDimmingView(to: 0)
        }

        override func size(forChildContentContainer container: UIContentContainer,
                           withParentContainerSize parentSize: CGSize) -> CGSize {
            return container.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }

        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)

            guard let containerView = containerView else { return }
            coordinator.animate { _ in
                self.dimmingView.frame = containerView.bounds
                self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            }
        }

        private func animateDimmingView(to alpha: CGFloat) {
            guard let coordinator = presentedViewController.transitionCoordinator else {
                if let dimmingView = dimmingView as? DimmingViewProtocol {
                    dimmingView.animateDimming(alpha)
                } else {
                    dimmingView.alpha = alpha
                }
                return
            }
            coordinator.animate { _ in
                if let dimmingView = self.dimmingView as? DimmingViewProtocol {
                    dimmingView.animateDimming(alpha)
                } else {
                    self.dimmingView.alpha = alpha
                }
            }
        }

        override func containerViewDidLayoutSubviews() {
            super.containerViewDidLayoutSubviews()
            presentedView?.frame = frameOfPresentedViewInContainerView
        }
    }
}
