//
//  CommonCollectionViewProtocol.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//
//  This file defines the CommonCollectionViewDelegate protocol for handling collection view cell selection,
//  and the CommonCollection class as a placeholder for common collection-related functionality.
//

import DesignCore
import UIKit

/// A delegate protocol to handle events related to the common collection view.
@objc public protocol CommonCollectionViewDelegate: AnyObject {
    /// Called when a collection view cell is selected.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the selected cell.
    ///   - data: The data model associated with the selected cell.
    @objc optional func didSelectCell(at indexPath: IndexPath, with data: CommonCollectionCellModel)
}

/// A class representing common collection-related functionality.
/// This class can be extended to provide shared utilities or behaviors for collections.
public class CommonCollection { }
