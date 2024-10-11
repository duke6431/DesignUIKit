//
//  CommonCollectionCell.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//

import DesignCore
import UIKit

@objc public protocol CommonCollectionCellModel: NSObjectProtocol {
    var identifier: String { get }
    static var cellKind: CommonCollection.CollectionCell.Type { get }
    var selectable: Bool { get }
    // swiftlint:disable:next line_length
    /// This function should only be used as emergency option when something need to be custom once or twice or when something is really needed on production
    var customConfiguration: ((CommonCollection.CollectionCell) -> Void)? { get set }
    var realData: Any? { get }
}

extension CommonCollection {
    open class CollectionCell: UICollectionViewCell, Reusable {
        public var identifier: String = ""
        public var indexPath: IndexPath?
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            configureViews()
        }
        
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        public required init?(coder: NSCoder) {
            fatalError("Not implemented")
        }
        
        open func bind(_ model: CommonCollectionCellModel) {
            fatalError("Must override this function")
        }
        
        open func configureViews() {
        }
    }
}
