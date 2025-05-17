//
//  CommonCollectionHeader.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//
//
//  CommonCollectionHeader.swift
//  DesignComponents
//
//  This file defines protocols and classes for reusable collection view headers and footers
//  in the DesignUIKit module. It provides a protocol for models describing reusable views
//  and a base class for reusable collection view supplementary views with configuration,
//  logging, and binding capabilities.
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//

import DesignCore
import UIKit

/// A protocol that represents a model for a reusable collection view supplementary view (header or footer).
///
/// Types conforming to this protocol provide information necessary for configuring and identifying
/// reusable views in a collection view.
@objc public protocol CommonCollectionReusableModel: NSObjectProtocol {
    /// The unique identifier for the reusable view model.
    var identifier: String { get }
    /// The type of reusable view (header or footer) associated with this model.
    static var headerKind: CommonCollection.ReusableView.Type { get }
    /// A closure for custom configuration of the reusable view.
    ///
    /// - Note: This should only be used as an emergency option when something needs to be customized
    ///   once or twice, or when something is really needed in production.
    var customConfiguration: ((CommonCollection.ReusableView) -> Void)? { get set }
}

extension CommonCollection {
    /// A base class for reusable collection view supplementary views (such as headers and footers).
    ///
    /// This class provides basic properties and methods for configuring and binding data to
    /// supplementary views, as well as logging deinitialization.
    open class ReusableView: UICollectionReusableView, Reusable, Loggable {
        /// The identifier for this reusable view instance.
        public var identifier: String = ""
        /// The section index associated with this reusable view, if any.
        public var section: Int?
        
        /// Initializes a new reusable view with the specified frame.
        ///
        /// - Parameter frame: The frame rectangle for the view, measured in points.
        public override init(frame: CGRect) {
            super.init(frame: frame)
            configureViews()
        }
        
        /// Unavailable initializer. Do not use.
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        public required init?(coder: NSCoder) {
            fatalError("Not implemented")
        }
        
        /// Binds the view to the provided model.
        ///
        /// - Parameter model: The model object conforming to `CommonCollectionReusableModel`.
        ///
        /// - Note: Subclasses must override this method to provide custom binding logic.
        open func bind(_ model: CommonCollectionReusableModel) {
            fatalError("Must override this function")
        }
        
        /// Configures subviews and layout for the reusable view.
        ///
        /// Subclasses can override this method to set up their view hierarchy and appearance.
        open func configureViews() {
        }
        
        /// Called when the reusable view is deallocated.
        ///
        /// Logs a trace message for debugging and memory management purposes.
        deinit {
            logger.trace("Deinitialized \(self)")
        }
    }
}
