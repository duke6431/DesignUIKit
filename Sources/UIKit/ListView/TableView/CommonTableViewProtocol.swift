//
//  CommonTableViewProtocol.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//
//  This file defines the CommonTableViewDelegate protocol and the CommonTableSection class,
//  which are used to manage and configure common table view behaviors and data structures
//  within the Components module.
//

import UIKit

/// A delegate protocol to handle common table view events such as refreshing, cell selection, and loading more data.
@objc public protocol CommonTableViewDelegate: AnyObject {
    /// Called when a refresh action is started.
    @objc optional func refreshStarted()
    
    /// Called when a cell is selected in the table view.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the selected cell.
    ///   - data: The data model associated with the selected cell.
    @objc optional func didSelectCell(at indexPath: IndexPath, with data: CommonCellModel)
    
    /// Called when more data needs to be loaded, typically for pagination.
    @objc optional func loadMore()
}

/// Represents a section in a common table view, containing an optional header and an array of cell models.
public class CommonTableSection {
    /// The header model for the section, if any.
    public var header: CommonHeaderModel?
    
    /// The array of cell models contained in this section.
    public var items: [CommonCellModel]
    
    /// Initializes a new CommonTableSection instance.
    ///
    /// - Parameters:
    ///   - header: An optional header model for the section. Defaults to nil.
    ///   - items: An array of cell models to be included in this section.
    public init(header: CommonHeaderModel? = nil, items: [CommonCellModel]) {
        self.header = header
        self.items = items
    }
}
