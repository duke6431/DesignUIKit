//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 26/9/24.
//

import UIKit
import RxSwift
import DesignUIKit
import DesignCore
import RxCocoa

public protocol Combinable: AnyObject {
    var disposeBag: DisposeBag { get set }
}

extension UIView: Combinable {
    static let disposeBag = ObjectAssociation<DisposeBag>()

    public var disposeBag: DisposeBag {
        get {
            if let disposeBag = Self.disposeBag[self] { return disposeBag }
            let disposeBag = DisposeBag()
            Self.disposeBag[self] = disposeBag
            return disposeBag
        }
        set { Self.disposeBag[self] = newValue }
    }
}

public extension FComponent where Self: UIView, Self: Combinable {
    @discardableResult func bind<Subject>(
        to publisher: Driver<Subject>,
        next: @escaping (Self, Subject) -> Void,
        error: ((Error) -> Void)? = nil,
        complete: (() -> Void)? = nil
    ) -> Self {
        let localET = ErrorTracker()
        disposeBag.insert {
            publisher.trackError(localET).drive { [weak self] in
                guard let self = self else { return }
                next(self, $0)
            } onCompleted: { complete?() }
            localET.drive(onNext: error)
        }
        return self
    }
}
