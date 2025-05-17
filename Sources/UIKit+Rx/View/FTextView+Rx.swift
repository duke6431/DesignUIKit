//
//  FTextView+Rx.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/09/26.
//
//  Adds RxSwift support for `FTextView` with reactive binding and text event forwarding.
//

import Foundation
import DesignUIKit
import RxCocoa
import RxSwift

public extension FTextView {
    /// Initializes an `FTextView` with a placeholder and binds its text to a reactive `Driver`.
    /// - Parameters:
    ///   - placeholder: The placeholder text to display.
    ///   - textPublisher: A `Driver<String>` providing the text to bind to the field.
    convenience init(
        _ placeholder: String,
        _ textPublisher: Driver<String>
    ) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.bind(to: textPublisher) { field, text in field.text = text }
        preconditions()
    }
    
    /// Sends updated text from the text view to a `PublishSubject`.
    /// - Parameter subject: The subject to emit text changes to.
    /// - Returns: Self for fluent chaining.
    func sendText(to subject: PublishSubject<String?>) -> Self {
        rx.text.bind(onNext: subject.onNext(_:)).disposed(by: disposeBag)
        return self
    }
}
