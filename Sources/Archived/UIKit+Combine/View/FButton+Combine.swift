//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import Foundation
import DesignCore
import DesignUIKit
import Combine
import UIKit

extension FButton {
    public convenience init(
        style: UIButton.ButtonType? = nil,
        _ textPublisher: FBinder<String>,
        action: @escaping () -> Void
    ) {
        self.init(style: style)
        self.bind(to: textPublisher) { button, title in
            button.setTitle(title, for: .normal)
        }
        addAction(for: Self.tapEvent, action)
    }
    
    public convenience init(
        style: UIButton.ButtonType? = nil,
        _ textPublisher: FBinder<String>,
        action: @escaping (FButton?) -> Void
    ) {
        self.init(style: style)
        self.bind(to: textPublisher) { button, title in
            button.setTitle(title, for: .normal)
        }
        addAction(for: Self.tapEvent, { [weak self] in action(self) })
    }
}
