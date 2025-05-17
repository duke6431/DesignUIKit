//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 26/9/24.
//

import Foundation
import DesignUIKit

extension FTextField {
    public convenience init(
        _ placeholder: String,
        _ textPublisher: FBinder<String>
    ) {
        self.init("", "")
        self.customPlaceholder = placeholder
        self.bind(to: textPublisher) { field, text in field.text = text }
        preconditions()
    }
}
