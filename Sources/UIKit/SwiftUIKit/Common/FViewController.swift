//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 2/23/24.
//

import UIKit
import DesignCore
import DesignExts

public final class FViewController<ViewController: UIViewController>: FViewControllerBase<ViewController>, FComponent {
    public var viewController: ViewController
    
    public var customConfiguration: ((ViewController, FViewController) -> ViewController)?
    
    public init(
        viewController: ViewController
    ) {
        self.viewController = viewController
        super.init(frame: .zero)
    }
    
    @discardableResult
    public override func rendered() -> ViewController {
        var controller = viewController
        backgroundColor = contentBackgroundColor
        controller = customConfiguration?(controller, self) ?? controller
        content = controller
        return controller
    }
}
