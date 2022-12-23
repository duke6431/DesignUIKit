//
//  CommonTableView+Rx.swift
//  RxComponents
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//

import UIKit
import RxSwift
import RxCocoa
import DesignComponents

extension Reactive where Base: CommonTableView {

    /// Reactive wrapper for `delegate`.
    ///
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    public var delegate: DelegateProxy<CommonTableView, CommonTableViewDelegate> {
        return RxCommonTableViewDelegateProxy.proxy(for: base)
    }

    public var refresh: Observable<Void> {
        return delegate.methodInvoked(#selector(CommonTableViewDelegate.refreshStarted)).map { _ in () }
    }

    public var didSelect: Observable<(indexPath: IndexPath, model: CommonCellModel)> {
        return delegate.methodInvoked(#selector(CommonTableViewDelegate.didSelectCell)).compactMap { params in
            if let indexPath = params.first as? IndexPath, let model = params[1] as? CommonCellModel {
                return (indexPath: indexPath, model: model)
            }
            return nil
        }
    }
}

extension CommonTableView: HasDelegate {
    public typealias Delegate = CommonTableViewDelegate
}

open class RxCommonTableViewDelegateProxy: DelegateProxy<CommonTableView, CommonTableViewDelegate>,
                                           DelegateProxyType, CommonTableViewDelegate {

    /// Typed parent object.
    public weak private(set) var view: CommonTableView?

    /// - parameter view: Parent object for delegate proxy.
    public init(view: CommonTableView) {
        self.view = view
        super.init(parentObject: view, delegateProxy: RxCommonTableViewDelegateProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxCommonTableViewDelegateProxy(view: $0) }
    }
}
