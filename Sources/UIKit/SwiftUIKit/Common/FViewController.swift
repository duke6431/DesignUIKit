//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/23/24.
//

import UIKit
import DesignCore
import DesignExts

public class FViewController: BaseView, FConfigurable, FComponent {
    public var customConfiguration: ((FViewController) -> Void)?

    public weak var parentViewController: UIViewController?
    public var contentViewController: UIViewController
    
    init(_ contentViewController: UIViewController) {
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
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    public func parent(_ viewController: UIViewController) -> Self {
        parentViewController = viewController
        return self
    }
}
