//
//  KeyboardProtocol.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 24/05/2022.
//

#if canImport(UIKit)
import UIKit

public protocol KeyRenderable {
    var multiplier: Keyboard.Multiplier { get }
    func multiply(_ value: Keyboard.Multiplier) -> Self
    func render() -> UIView
}

protocol KeyTappable {
    func tap()
}

protocol KeyTappableDelegate: AnyObject {
    func didTap(action: Key.Kind)
}
#endif
