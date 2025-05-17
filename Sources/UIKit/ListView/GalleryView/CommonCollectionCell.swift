//
//  CommonCollectionCell.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//
//  This file defines the CommonCollectionCellModel protocol and the CommonCollection.CollectionCell class,
//  which are used as part of the common collection view cell infrastructure. 
//  The protocol specifies the requirements for cell models, including identifiers, cell kinds, and customization closures.
//  The CollectionCell class provides a base UICollectionViewCell implementation with reusable and logging capabilities.
//

import DesignCore
import UIKit

/// A protocol that defines the model requirements for a common collection view cell.
/// Conforming types must provide an identifier, the cell class type, selection capability,
/// an optional custom configuration closure, and optional real data.
@objc public protocol CommonCollectionCellModel: NSObjectProtocol {
    /// A unique identifier string for the cell model.
    var identifier: String { get }
    
    /// The type of the collection cell class associated with this model.
    static var cellKind: CommonCollection.CollectionCell.Type { get }
    
    /// A Boolean indicating whether the cell is selectable.
    var selectable: Bool { get }
    
    /// A closure for custom configuration of the collection cell.
    /// This should only be used as an emergency option when customization is needed once or twice,
    /// or when something is critically required in production.
    var customConfiguration: ((CommonCollection.CollectionCell) -> Void)? { get set }
    
    /// Optional real data associated with the model.
    var realData: Any? { get }
}

extension CommonCollection {
    /// A base collection view cell class used within CommonCollection.
    /// This class conforms to `Reusable` and `Loggable` protocols and provides basic setup and binding functionality.
    open class CollectionCell: UICollectionViewCell, Reusable, Loggable {
        /// The identifier string for the cell instance.
        public var identifier: String = ""
        
        /// The index path of the cell in the collection view.
        public var indexPath: IndexPath?
        
        /// Initializes a new collection cell with the given frame.
        /// Calls `configureViews()` after initialization for further setup.
        ///
        /// - Parameter frame: The frame rectangle for the cell.
        public override init(frame: CGRect) {
            super.init(frame: frame)
            configureViews()
        }
        
        /// Initialization from storyboard or nib is unavailable.
        ///
        /// - Parameter coder: The coder instance.
        /// - Returns: This initializer always throws a fatal error.
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        public required init?(coder: NSCoder) {
            fatalError("Not implemented")
        }
        
        /// Binds the cell with the given model.
        /// Subclasses must override this method to implement custom binding behavior.
        ///
        /// - Parameter model: The model conforming to `CommonCollectionCellModel` to bind to the cell.
        open func bind(_ model: CommonCollectionCellModel) {
            fatalError("Must override this function")
        }
        
        /// Configures the views of the cell.
        /// This method is called during initialization and can be overridden by subclasses to setup subviews.
        open func configureViews() {
        }
        
        /// Deinitializer for the collection cell.
        /// Logs a trace message when the cell is deinitialized if CORE_DEBUG is enabled.
        deinit {
#if CORE_DEBUG
            logger.trace("Deinitialized \(self)")
#endif
        }
    }
}
