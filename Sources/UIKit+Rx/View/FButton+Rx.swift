//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import Foundation
import DesignCore
import DesignUIKit
import UIKit
import RxCocoa
import RxSwift

public extension FButton {
    convenience init(
        style: UIButton.ButtonType? = nil,
        _ textPublisher: Driver<String>
    ) {
        self.init(style: style)
        textPublisher.drive(onNext: { [weak self] in self?.setTitle($0, for: .normal) }).disposed(by: disposeBag)
    }

    @discardableResult
    func onTap(trigger publisher: PublishSubject<Void>) -> Self {
        rx.tap.bind(onNext: publisher.onNext).disposed(by: disposeBag)
        return self
    }
}
