//
//  FTextField+Rx.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/09/26.
//
//  Adds RxSwift binding support for `FTextField`, allowing reactive updates and
//  value forwarding through publishers and control events.
//

import Foundation
import DesignUIKit
import RxCocoa
import RxSwift

public extension FTextField {
    /// Initializes an `FTextField` with a placeholder and binds its text to a reactive stream.
    /// - Parameters:
    ///   - placeholder: The placeholder text to display.
    ///   - textPublisher: A `Driver<String>` stream to bind the field’s text.
    convenience init(
        _ placeholder: String,
        _ textPublisher: Driver<String>
    ) {
        self.init("", "")
        self.customPlaceholder = placeholder
        self.bind(to: textPublisher) { field, text in field.text = text }
        preconditions()
    }
    
    /// Binds the text of the text field to a `PublishSubject`.
    /// - Parameter subject: A subject that receives the field’s current text whenever it changes.
    /// - Returns: Self for fluent chaining.
    func sendText(to subject: PublishSubject<String?>) -> Self {
        rx.text.bind(onNext: subject.onNext(_:)).disposed(by: disposeBag)
        return self
    }
    
    /// Emits the current text of the field to the subject when the return key is pressed.
    /// - Parameter subject: A subject that receives the field’s text on `.editingDidEndOnExit`.
    /// - Returns: Self for fluent chaining.
    func sendReturn(to subject: PublishSubject<String?>) -> Self {
        rx.controlEvent(.editingDidEndOnExit).map { [weak self] in
            self?.text
        }.bind(onNext: subject.onNext(_:)).disposed(by: disposeBag)
        return self
    }
}
