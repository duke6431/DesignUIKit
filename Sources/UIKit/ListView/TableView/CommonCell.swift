//
//  CommonCell.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

#if canImport(UIKit)
@objc public protocol CommonCellModel: NSObjectProtocol {
    var identifier: String { get }
    static var cellKind: CommonTableView.Cell.Type { get }
    var selectable: Bool { get }
    // swiftlint:disable:next line_length
    /// This function should only be used as emergency option when something need to be custom once or twice or when something is really needed on production
    var customConfiguration: ((CommonTableView.Cell) -> Void)? { get set }
    var leadingActions: [UIContextualAction] { get set }
    var trailingActions: [UIContextualAction] { get set }
    var realData: Any? { get }

    @objc optional func isHighlighted(with keyword: String) -> Bool
}
extension CommonTableView {
    @objc open class Cell: UITableViewCell, Reusable {
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
        }
    }
}
#endif
