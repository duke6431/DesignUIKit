//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import Foundation
import DesignCore
import RxSwift
import RxCocoa

public protocol ViewModeling {
    func connect(with disposeBag: DisposeBag)
}

public extension ViewModeling where Self: BaseViewModel {
    func register<T>(to path: ReferenceWritableKeyPath<Self, PublishSubject<T>>, with subject: Observable<T>) {
        subject.subscribe(onNext: self[keyPath: path].onNext(_:)).store(in: &cancellables)
    }
}

open class BaseViewModel: ViewModeling {
    public var cancellables: [Disposable] = []
    
    public required init() {
        bind()
    }
    
    func bind() { }
    
    open func connect(with disposeBag: DisposeBag) {
        cancellables.forEach(disposeBag.insert(_:))
        cancellables.removeAll()
    }
}

public extension Disposable {
    func store(in cancellables: inout [Disposable]) {
        cancellables.append(self)
    }
}
