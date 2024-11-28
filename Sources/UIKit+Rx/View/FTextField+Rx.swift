//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import Foundation
import DesignUIKit
import RxCocoa
import RxSwift

public extension FTextField {
    convenience init(
        _ placeholder: String,
        _ textPublisher: Driver<String>
    ) {
        self.init("", "")
        self.customPlaceholder = placeholder
        self.bind(to: textPublisher) { field, text in field.text = text }
        preconditions()
    }
    
    func sendText(to subject: PublishSubject<String?>) -> Self {
        rx.text.bind(onNext: subject.onNext(_:)).disposed(by: disposeBag)
        return self
    }
    
    func sendReturn(to subject: PublishSubject<String?>) -> Self {
        rx.controlEvent(.editingDidEndOnExit).map { [weak self] in
            self?.text
        }.bind(onNext: subject.onNext(_:)).disposed(by: disposeBag)
        return self
    }
}
