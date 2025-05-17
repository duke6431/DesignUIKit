//
//  FLabel+Rx.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/09/26.
//
//  Adds a convenience initializer to `FLabel` for binding reactive text streams using RxSwift.
//

import Foundation
import DesignUIKit
import RxCocoa

public extension FLabel {
    /// Initializes an `FLabel` and binds its text to the provided `Driver<String>`.
    /// - Parameter textPublisher: A `Driver` stream that emits new label text values.
    convenience init(
        _ textPublisher: Driver<String>
    ) {
        self.init("")
        self.bind(to: textPublisher) { label, text in label.text = text }
    }
}
