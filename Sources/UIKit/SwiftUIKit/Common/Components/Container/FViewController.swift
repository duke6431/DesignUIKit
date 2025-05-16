//
//  File.swift
//
//
//  Created by Duc Minh Nguyen on 2/23/24.
//

import UIKit
import SnapKit
import DesignCore
import DesignExts
import Foundation

public class FViewController: BaseView, FComponent {
    public var customConfiguration: ((FViewController) -> Void)?

    public weak var parentViewController: UIViewController?
    public var contentViewController: UIViewController

    public init(_ contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(frame: .zero)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        guard let parentViewController else { return }
        contentViewController.willMove(toParent: parentViewController)
        parentViewController.addChild(contentViewController)
        addSubview(contentViewController.view)
        contentViewController.didMove(toParent: parentViewController)
        contentViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        customConfiguration?(self)
    }

    public override func removeFromSuperview() {
        parentViewController = nil
        contentViewController.willMove(toParent: nil)
        contentViewController.view.removeFromSuperview()
        contentViewController.removeFromParent()
        super.removeFromSuperview()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }

    @discardableResult public func parent(_ viewController: UIViewController) -> Self {
        parentViewController = viewController
        return self
    }

    deinit {
        removeFromSuperview()
        logger.trace("Deinitialized \(self)")
    }
}

public class FViewContainer: UIViewController, Chainable, Loggable {
    public var content: FBody

    var onLoad: ((FViewContainer) -> Void)?
    var onAppear: ((FViewContainer) -> Void)?
    var onDisappear: ((FViewContainer) -> Void)?

    public convenience init(@FViewBuilder _ content: () -> FBody) {
        self.init(content())
    }

    public init(_ content: FBody) {
        self.content = FZStack(contentViews: content).ignoreSafeArea(true)
        super.init(nibName: nil, bundle: .main)
    }

    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) { fatalError("Unimplemented") }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(content)
        onLoad?(self)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear?(self)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onDisappear?(self)
    }

    deinit {
        logger.trace("Deinitialized \(self)")
    }
}

public extension FViewContainer {
    func onLoad(_ action: @escaping (FViewContainer) -> Void) -> Self {
        onLoad = action
        return self
    }

    func onAppear(_ action: @escaping (FViewContainer) -> Void) -> Self {
        onAppear = action
        return self
    }

    func onDisappear(_ action: @escaping (FViewContainer) -> Void) -> Self {
        onDisappear = action
        return self
    }
}
