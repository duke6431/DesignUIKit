//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/23/24.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import SnapKit
import DesignCore
import DesignExts

public class FViewController<ViewController: BViewController>: BaseView, FComponent {
    public var layoutConfiguration: ((ConstraintMaker) -> Void)?
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
        if let layoutConfiguration, superview != nil {
            snp.makeConstraints(layoutConfiguration)
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
