//
//  CommonHeader.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//
//  This file defines the CommonHeaderModel protocol and the CommonTableView.Header class,
//  which are used to manage and configure table view header views in a reusable and customizable manner.
//

import UIKit

/// A protocol that defines the requirements for a model representing a common table view header.
/// Conforming types must provide an identifier, specify the header view type, and optionally provide a custom configuration closure.
@objc public protocol CommonHeaderModel: NSObjectProtocol {
    /// A unique identifier for the header model.
    var identifier: String { get }
    
    /// The type of the header view associated with this model.
    static var headerKind: CommonTableView.Header.Type { get }
    
    /// A closure that allows custom configuration of the header view.
    /// This should be used sparingly, only for one-off customizations or critical production needs.
    var customConfiguration: ((CommonTableView.Header) -> Void)? { get set }
}

extension CommonTableView {
    /// A reusable table view header/footer view that can be bound to a CommonHeaderModel.
    /// Subclasses should override the `bind(_:)` method to configure the view with the provided model.
    @objc open class Header: UITableViewHeaderFooterView {
        /// The identifier associated with this header view.
        public var identifier: String = ""
        
        /// The section index this header belongs to, if applicable.
        public var section: Int?
        
        /// Initializes a new header view with the specified reuse identifier.
        /// - Parameter reuseIdentifier: The reuse identifier for the header view.
        public override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configureViews()
        }
        
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        /// This initializer is not implemented and will cause a runtime error if called.
        public required init?(coder: NSCoder) {
            fatalError("Not implemented")
        }
        
        /// Binds the header view to the provided model.
        /// Subclasses must override this method to update the view based on the model data.
        /// - Parameter model: The model to bind to the header view.
        open func bind(_ model: CommonHeaderModel) {
            fatalError("Must override this function")
        }
        
        /// Configures the subviews and layout of the header view.
        /// Subclasses can override this method to set up their custom views.
        open func configureViews() { }
    }
}
