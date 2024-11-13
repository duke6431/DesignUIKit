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

extension FButton {
    public convenience init(
        style: UIButton.ButtonType? = nil,
        _ textPublisher: Driver<String>,
        action: @escaping () -> Void
    ) {
        self.init(style: style)
        textPublisher.drive(onNext: { [weak self] in self?.setTitle($0, for: .normal) }).disposed(by: disposeBag)
    }

    public convenience init(
        style: UIButton.ButtonType? = nil,
        _ textPublisher: Driver<String>,
        action: @escaping (FButton?) -> Void
    ) {
        self.init(style: style)
        textPublisher.drive(onNext: { [weak self] in self?.setTitle($0, for: .normal) }).disposed(by: disposeBag)
    }

    func sendTap(to subject: PublishSubject<Void>) -> Self {
        rx.tap.bind(onNext: subject.onNext).disposed(by: disposeBag)
        return self
    }
}
