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

extension FTextView {
    public convenience init(
        _ placeholder: String,
        _ textPublisher: Driver<String>
    ) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.bind(to: textPublisher) { field, text in field.text = text }
        preconditions()
    }
    
    func sendText(to subject: PublishSubject<String?>) -> Self {
        rx.text.bind(onNext: subject.onNext(_:)).disposed(by: disposeBag)
        return self
    }
}
