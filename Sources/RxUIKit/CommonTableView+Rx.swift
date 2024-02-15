//
//  CommonTableView+Rx.swift
//  RxComponents
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//

import UIKit
import RxSwift
import RxCocoa
import DesignUIKit

extension Reactive where Base: CommonTableView {
    public var refresh: Observable<Void> { base.rx.methodInvoked(#selector(CommonTableView.startRefreshing)).void() }
    
    public var didSelect: Observable<(indexPath: IndexPath, model: CommonCellModel)> {
        base.rx.methodInvoked(#selector(CommonTableView.didSelectCell(at:with:))).compactMap { params in
            if let indexPath = params.first as? IndexPath, let model = params[1] as? CommonCellModel {
                return (indexPath: indexPath, model: model)
            }
            return nil
        }
    }
    
    public var data: Binder<[CommonTableSection]> {
        .init(base) { base, section in base.reloadData(sections: section) }
    }
}
