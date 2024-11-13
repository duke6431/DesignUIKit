//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import Foundation
import DesignUIKit
import RxCocoa

extension FTextField {
    public convenience init(
        _ placeholder: String,
        _ textPublisher: Driver<String>
    ) {
        self.init("", "")
        self.customPlaceholder = placeholder
        self.bind(to: textPublisher) { field, text in field.text = text }
        preconditions()
    }
}
