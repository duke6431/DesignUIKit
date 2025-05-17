//
//  CommonCell.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//
//  This file defines the CommonCellModel protocol and the CommonTableView.TableCell class,
//  which provide a standardized way to configure and display table view cells within the app's UI components.

import UIKit

/// Protocol defining the requirements for a model used by `CommonTableView.TableCell`.
/// Conforming types provide information necessary to configure and manage table view cells.
@objc public protocol CommonCellModel: NSObjectProtocol {
    /// A unique identifier for the cell model instance.
    var identifier: String { get }
    
    /// The type of the cell class associated with this model.
    static var cellKind: CommonTableView.TableCell.Type { get }
    
    /// Indicates whether the cell is selectable.
    var selectable: Bool { get }
    
    /// A closure for custom configuration of the cell.
    /// This should be used sparingly for one-off customizations or critical production needs.
    var customConfiguration: ((CommonTableView.TableCell) -> Void)? { get set }
    
#if os(iOS)
    /// Array of leading swipe actions for the cell (iOS only).
    var leadingActions: [UIContextualAction] { get set }
    
    /// Array of trailing swipe actions for the cell (iOS only).
    var trailingActions: [UIContextualAction] { get set }
#endif
    
    /// The underlying data represented by the model.
    var realData: Any? { get }
    
    /// Optional method to determine if the cell should be highlighted based on a search keyword.
    /// - Parameter keyword: The search keyword to check for highlighting.
    /// - Returns: `true` if the cell matches the keyword and should be highlighted; otherwise, `false`.
    @objc optional func isHighlighted(with keyword: String) -> Bool
}

extension CommonTableView {
    /// A reusable table view cell class to be subclassed for custom cell implementations.
    /// Provides basic initialization and a binding interface for the cell model.
    @objc open class TableCell: UITableViewCell, Reusable {
        /// The identifier associated with the cell.
        public var identifier: String = ""
        
        /// The index path of the cell within the table view.
        public var indexPath: IndexPath?
        
        /// Initializes the cell with a given style and reuse identifier.
        /// - Parameters:
        ///   - style: The cell style.
        ///   - reuseIdentifier: The reuse identifier for the cell.
        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            configureViews()
        }
        
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        /// Initialization from a coder is not supported.
        /// - Parameter coder: The coder to initialize from.
        public required init?(coder: NSCoder) {
            fatalError("Not implemented")
        }
        
        /// Binds the given model to the cell and applies text highlighting if needed.
        /// Subclasses must override this method to configure the cell's content.
        /// - Parameters:
        ///   - model: The cell model to bind.
        ///   - text: The text to highlight within the cell content.
        open func bind(_ model: CommonCellModel, highlight text: String) {
            fatalError("Must override this function")
        }
        
        /// Configures the cell's views.
        /// Subclasses can override this method to set up UI components.
        open func configureViews() { }
    }
}
