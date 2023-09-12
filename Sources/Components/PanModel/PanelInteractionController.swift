//
//  PanelInteractionController.swift
//  Duc Nguyen
//
//  Created by Duc IT. Nguyen Minh on 15/06/2022.
//

import UIKit

extension PanModal {
    class InteractionController: UIPercentDrivenInteractiveTransition {
        private(set) var interactionInProgress = false
        private var shouldCompleteTransition = false
        private var beginTranslationY: CGFloat = 0
        private var gestures: [UIGestureRecognizer] = []
        private weak var viewController: UIViewController?
        private var direction: OriginDirection

        init(direction: OriginDirection) {
            self.direction = direction
        }

        func wireToViewController(viewController: UIViewController, interactive: Bool = true) {
            self.viewController = viewController
            if interactive {
                updateGesture(for: viewController.view, type: UIPanGestureRecognizer.self,
                              target: self, action: #selector(handlePanGestureRecognizer))
            }
        }

        func wireToView(view: UIView, interactive: Bool = true) {
            if interactive {
                updateGesture(for: view, type: UIPanGestureRecognizer.self, target: self,
                              action: #selector(handlePanGestureRecognizer))
                updateGesture(for: view, type: UITapGestureRecognizer.self, target: self,
                              action: #selector(handleTapGestureRecognizer))
            }
        }

        func updateGesture<T: UIGestureRecognizer>(for view: UIView, type: T.Type, target: Any?, action: Selector?) {
            let gestureRecognizer = T.init(target: target, action: action)
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
            gestures.append(gestureRecognizer)
        }

        @objc private func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
            viewController?.dismiss(animated: true)
        }

        // MARK: Private
        @objc private func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
            guard let view = gestureRecognizer.view, let superview = view.superview else {
                return
            }

            switch gestureRecognizer.state {
            case .changed:
                if let scrollView = gestureRecognizer.view as? UIScrollView
                    ?? gestureRecognizer.view?.subviews.first as? UIScrollView,
                    direction == .bottom
                    ? scrollView.contentOffset.y > 0
                    : scrollView.contentOffset.y < 0, percentComplete == 0 {
                    return
                }
                let translation = gestureRecognizer.translation(in: superview)
                if direction == .bottom ? translation.y < 0 : translation.y > 0 {
                    return
                }
                let rawProgress = abs(translation.y - beginTranslationY) / view.bounds.height
                let progress = CGFloat(fminf(fmaxf(Float(rawProgress), 0), 1))

                if interactionInProgress {
                    shouldCompleteTransition = progress > 0.4
                    update(progress)
                } else {
                    interactionInProgress.toggle()
                    beginTranslationY = direction == .bottom ? translation.y : -translation.y
                    viewController?.dismiss(animated: true)
                }
            case .cancelled, .failed, .ended:
                interactionInProgress = false
                beginTranslationY = 0

                if shouldCompleteTransition {
                    finish()
                } else {
                    cancel()
                }
            default:
                break
            }
        }
    }
}

extension PanModal.InteractionController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
