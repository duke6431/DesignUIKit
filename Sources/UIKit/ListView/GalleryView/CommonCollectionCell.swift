//
//  CommonCollectionCell.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//

import DesignCore
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

@objc public protocol CommonCollectionCellModel: NSObjectProtocol {
    var identifier: String { get }
    static var cellKind: CommonCollection.Cell.Type { get }
    var selectable: Bool { get }
    // swiftlint:disable:next line_length
    /// This function should only be used as emergency option when something need to be custom once or twice or when something is really needed on production
    var customConfiguration: ((CommonCollection.Cell) -> Void)? { get set }
    var realData: Any? { get }
}

extension CommonCollection {
#if canImport(UIKit)
    open class Cell: UICollectionViewCell, Reusable {
        public var identifier: String = ""
        public var indexPath: IndexPath?

        public override init(frame: CGRect) {
            super.init(frame: frame)
            configureViews()
        }

        @available(iOS, unavailable)
        public required init?(coder: NSCoder) {
            fatalError("Not implemented")
        }

        open func bind(_ model: CommonCollectionCellModel) {
            fatalError("Must override this function")
        }

        open func configureViews() {
        }
    }
#else
    open class Cell: NSCollectionViewItem, Reusable {
        public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            configureViews()
        }
        
        @available(macOS, unavailable)
        required public init(coder: NSCoder) {
            fatalError()
        }
        
        open func bind(_ model: CommonCollectionCellModel) {
            fatalError("Must override this function")
        }

        open func configureViews() {
        }
    }
#endif
}
