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

extension FButton {
    public convenience init(
        style: UIButton.ButtonType? = nil,
        _ textPublisher: Driver<String>,
        action: @escaping () -> Void
    ) {
        self.init(style: style)
        textPublisher.drive(onNext: { [weak self] in self?.setTitle($0, for: .normal) }).disposed(by: disposeBag)
        addAction(for: Self.tapEvent, action)
    }

    public convenience init(
        style: UIButton.ButtonType? = nil,
        _ textPublisher: Driver<String>,
        action: @escaping (FButton?) -> Void
    ) {
        self.init(style: style)
        textPublisher.drive(onNext: { [weak self] in self?.setTitle($0, for: .normal) }).disposed(by: disposeBag)
        addAction(for: Self.tapEvent, { [weak self] in action(self) })
    }
}
