//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 26/9/24.
//

import Foundation
import DesignUIKit

extension FLabel {
    public convenience init(
        _ textPublisher: FBinder<String>
    ) {
        self.init("")
        self.bind(to: textPublisher) { label, text in label.text = text }
    }
}
