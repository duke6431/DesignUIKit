//
//  FButton+Rx.swift
//  DesignRxUIKit
//
//  Created by Duke Nguyen on 2024/09/26.
//
//  Extensions for `FButton` to support RxSwift binding for dynamic titles and tap events.
//

import Foundation
import DesignCore
import DesignUIKit
import UIKit
import RxCocoa
import RxSwift

public extension FButton {
    /// Initializes an `FButton` with a reactive title from a `Driver<String>` and an action.
    /// - Parameters:
    ///   - style: The button style type (optional).
    ///   - textPublisher: A `Driver` emitting button titles.
    convenience init(
        style: UIButton.ButtonType? = nil,
        _ textPublisher: Driver<String>
    ) {
        self.init(style: style)
        textPublisher.drive(onNext: { [weak self] in self?.setTitle($0, for: .normal) }).disposed(by: disposeBag)
    }

    /// Binds the button's tap event to a `PublishSubject`.
    /// - Parameter subject: The subject to forward tap events to.
    /// - Returns: Self for fluent chaining.
    @discardableResult
    func onTap(trigger publisher: PublishSubject<Void>) -> Self {
        rx.tap.bind(onNext: publisher.onNext).disposed(by: disposeBag)
        return self
    }
}
