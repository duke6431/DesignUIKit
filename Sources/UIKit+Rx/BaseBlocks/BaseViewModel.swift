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

public protocol ViewModeling { }

public extension ViewModeling where Self: BaseViewModel {
    func register<T>(to path: ReferenceWritableKeyPath<Self, PublishSubject<T>>, with subject: Observable<T>) {
        subject.subscribe(onNext: self[keyPath: path].onNext(_:)).disposed(by: disposeBag)
    }
}

open class BaseViewModel: ViewModeling {
    open var disposeBag = DisposeBag()
    
    public init() { }
}
