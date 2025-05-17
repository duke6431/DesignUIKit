//
//  KeyboardProtocol.swift
//  Components
//
//  Created by Duke Nguyen on 24/05/2022.
//

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
