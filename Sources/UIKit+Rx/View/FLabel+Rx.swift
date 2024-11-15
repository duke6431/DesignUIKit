//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import Foundation
import DesignUIKit
import RxCocoa

public extension FLabel {
    convenience init(
        _ textPublisher: Driver<String>
    ) {
        self.init("")
        self.bind(to: textPublisher) { label, text in label.text = text }
    }
}
