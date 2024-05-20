//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/23/24.
//

import SnapKit
import DesignCore
import DesignExts
import Combine
import Foundation

public class FViewController<ViewController: BViewController>: BaseView, FComponent {
    public var customConfiguration: ((FViewController) -> Void)?

    public weak var parentViewController: BViewController?
    public var contentViewController: ViewController
    
    public init(_ contentViewController: ViewController) {
        self.contentViewController = contentViewController
        super.init(frame: .zero)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        guard let parentViewController else { return }
        contentViewController.willMove(toParent: parentViewController)
        addSubview(contentViewController.view)
        parentViewController.addChild(contentViewController)
        contentViewController.didMove(toParent: parentViewController)
        contentViewController.view.snp.makeConstraints {
            $0.edges.equalTo(superview!.safeAreaLayoutGuide)
        }
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    @discardableResult public func parent(_ viewController: BViewController) -> Self {
        parentViewController = viewController
        return self
    }
}

public class FViewContainer: BViewController, Chainable {
    public var content: BView
    
    var onLoad: ((FViewContainer) -> Void)?
    var onAppear: ((FViewContainer) -> Void)?
    var onDisappear: ((FViewContainer) -> Void)?
    
    public convenience init(@FViewBuilder _ content: () -> FBody) {
        self.init(content())
    }
    
    public init(_ content: FBody) {
        self.content = FZStack(contentViews: content)
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(iOS, unavailable)
    public required init?(coder: NSCoder) { fatalError("Unimplemented") }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(content)
        content.snp.makeConstraints { $0.edges.equalToSuperview() }
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
