//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/23/24.
//

import UIKit
import DesignCore
import DesignExts

public final class FViewController: FViewControllerBase<UIViewController>, FComponent {
    public var viewController: UIViewController
    
    public var customConfiguration: ((UIViewController, FViewController) -> UIViewController)?
    
    public init(
        viewController: UIViewController
    ) {
        self.viewController = viewController
        super.init(frame: .zero)
    }
    
    @discardableResult
    public override func rendered() -> UIViewController {
        var controller = viewController
        backgroundColor = contentBackgroundColor
        controller = customConfiguration?(controller, self) ?? controller
        content = controller
        return controller
    }
}
