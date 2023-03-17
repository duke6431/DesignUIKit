//
//  CommonCollectionCell.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//

import DesignCore
import UIKit
#if canImport(DesignToolbox)
import DesignToolbox
#endif

@objc public protocol CommonCollectionCellModel: NSObjectProtocol {
    var identifier: String { get }
    var selectable: Bool { get }
    // swiftlint:disable:next line_length
    /// This function should only be used as emergency option when something need to be custom once or twice or when something is really needed on production
    var customConfiguration: ((CommonCollection.Cell) -> Void)? { get set }
    var realData: Any? { get }
}

extension CommonCollection {
    open class Cell: UICollectionViewCell, ReuseIdentifying {
#if canImport(DesignToolbox)
        public weak var currentTheme: Theme?
#endif
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
#if canImport(DesignToolbox)
            Theme.provider.register(observer: self)
#endif
        }
#if canImport(DesignToolbox)
        open func apply(theme: Theme) {
            currentTheme = theme
            backgroundColor = .clear
            contentView.backgroundColor = .clear
        }
#endif
    }
}
#if canImport(DesignToolbox)
extension CommonCollection.Cell: Themable { }
#endif
