//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 26/9/24.
//

import Foundation
import DesignUIKit

extension FTextView {
    public convenience init(
        _ placeholder: String,
        _ textPublisher: FBinder<String>
    ) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.bind(to: textPublisher) { field, text in field.text = text }
        preconditions()
    }
}
