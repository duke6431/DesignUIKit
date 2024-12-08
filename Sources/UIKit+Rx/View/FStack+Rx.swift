//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 7/12/24.
//

import DesignUIKit

public extension FStack {
    func bind<Content>(to dataPublisher: Driver<Content>, content renderer: @escaping (Content) -> FBodyComponent?) -> Self {
        dataPublisher.compactMap(renderer).drive(onNext: { [weak self] in
            guard let self else { return }
            arrangedSubviews.forEach { $0.removeFromSuperview() }
            addArrangedSubview($0)
        }).disposed(by: disposeBag)
        return self
    }
}
