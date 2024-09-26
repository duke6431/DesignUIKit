//
//  PanModelViewController.swift
//  Duc Nguyen
//
//  Created by Duc IT. Nguyen Minh on 15/06/2022.
//

import DesignCore
import UIKit

extension PanModal {
    public class ViewController: BViewController {
        var contentConfigure: ((BView, BViewController) -> Void)?
        var direction: OriginDirection
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        public init(direction: OriginDirection = .bottom) {
            self.direction = direction
            super.init(nibName: nil, bundle: nil)
        }
        
        // MARK: - Views
        public private(set) lazy var contentView: BView = {
            let view = BView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 16
            view.layer.masksToBounds = true
            self.view.addSubview(view)
            view.backgroundColor = .white
            return view
        }()
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            configurationUI()
        }
        
        // MARK: - Functions
        private func configurationUI() {
            NSLayoutConstraint.activate {
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                contentView.heightAnchor.constraint(equalToConstant: 500).with(\.priority, setTo: .defaultLow + 250)
                
                direction == .top
                // swiftlint:disable:next void_function_in_ternary
                ? contentView.topAnchor.constraint(equalTo: view.topAnchor)
                : contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            }
            contentConfigure?(contentView, self)
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()
        }
    }
}

extension PanModal.ViewController {
    public override func size(forChildContentContainer container: UIContentContainer,
                              withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: contentView.frame.size.height)
    }
}

extension BViewController {
    func prepareToPresentAsPanel(with dimmingView: BView?,
                                 direction: PanModal.OriginDirection = .bottom) {
        _storedTransitioningDelegate = PanModal.TransitioningDelegate(dimmingView: dimmingView, direction: direction)
        transitioningDelegate = _storedTransitioningDelegate
        modalPresentationStyle = .custom
    }
    
    public func present(_ viewController: BViewController?, dimmingView: BView? = nil,
                        direction: PanModal.OriginDirection = .top, animated: Bool = true) {
        let panel = PanModal.ViewController(direction: direction)
        panel.prepareToPresentAsPanel(with: dimmingView, direction: direction)
        if let viewController = viewController {
            panel.contentConfigure = { view, panel in
                view.addSubview(viewController.view)
                viewController.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate {
                    viewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
                    viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                    viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                    viewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                }
                panel.addChild(viewController)
                viewController.didMove(toParent: panel)
            }
        }
        present(panel, animated: animated)
    }
    
    private struct AssociatedKeys {
        static var TransitioningDelegate: UInt8 = 0
    }
    
    fileprivate var _storedTransitioningDelegate: UIViewControllerTransitioningDelegate? {
        get {
            return objc_getAssociatedObject(
                self, &AssociatedKeys.TransitioningDelegate
            ) as? UIViewControllerTransitioningDelegate
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.TransitioningDelegate,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

extension BView: Chainable {
    public static var dimmingDefault: BView {
        .init().with(\.backgroundColor, setTo: BColor.black.withAlphaComponent(0.4))
    }
}

extension NSLayoutConstraint: Chainable { }
