//
//  UINavigationController+.swift
//  DesignKit
//
//  Created by Duc IT. Nguyen Minh on 09/01/2023.
//

import UIKit
import DesignCore
import DesignToolbox

public extension UINavigationController {
    @available(iOS 13.0, *)
    func autoDetectLeftItem(animated: Bool = true, color: UIColor = .black) {
        autoDetectLeftItem(animated: animated,
                           image: .init(systemName: isBeingPresented ? "xmark" : "chevron.backward"),
                           color: color)
    }

    func autoDetectLeftItem(animated: Bool = true, image: UIImage?, color: UIColor = .black) {
        guard let image else { return }
        navigationBar.tintColor = color
        topViewController?.navigationItem.backBarButtonItem?.title = ""
        let isBeingPresented = presentingViewController?.presentedViewController == self
        let sleeve = ClosureSleeve(
            isBeingPresented
            ? { [weak self] in self?.dismiss(animated: animated) }
            : { [weak self] in self?.popViewController(animated: animated) }
        )
        let action = UIBarButtonItem(image: image, style: .done,
                                     target: sleeve, action: #selector(ClosureSleeve.invoke))
        objc_setAssociatedObject(action, UUID().uuidString, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        topViewController?.navigationItem.leftBarButtonItem = action
    }
}
