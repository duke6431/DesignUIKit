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

public class FViewController<ViewController: UIViewController>: BaseView, FConfigurable, FComponent {
    public var customConfiguration: ((FViewController) -> Void)?

    public weak var parentViewController: UIViewController?
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
    
    @discardableResult public func parent(_ viewController: UIViewController) -> Self {
        parentViewController = viewController
        return self
    }
}
