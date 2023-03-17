//
//  CommonCell.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//

import UIKit
#if canImport(DesignToolbox)
import DesignToolbox
#endif

@objc public protocol CommonCellModel: NSObjectProtocol {
    var identifier: String { get }
    var selectable: Bool { get }
    // swiftlint:disable:next line_length
    /// This function should only be used as emergency option when something need to be custom once or twice or when something is really needed on production
    var customConfiguration: ((CommonCell) -> Void)? { get set }
    var leadingActions: [UIContextualAction] { get set }
    var trailingActions: [UIContextualAction] { get set }
    var realData: Any? { get }
    func isHighlighted(with keyword: String) -> Bool
}

@objc open class CommonCell: UITableViewCell, ReuseIdentifying {
#if canImport(DesignToolbox)
    public weak var currentTheme: Theme?
#endif
    public var identifier: String = ""
    public var indexPath: IndexPath?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    open func bind(_ model: CommonCellModel, highlight text: String) {
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

#if canImport(DesignToolbox)
extension CommonCell: Themable { }
#endif
