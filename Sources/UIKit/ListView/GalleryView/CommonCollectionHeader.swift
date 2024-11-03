//
//  CommonCollectionHeader.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//

import DesignCore
import UIKit

@objc public protocol CommonCollectionReusableModel: NSObjectProtocol {
    var identifier: String { get }
    static var headerKind: CommonCollection.ReusableView.Type { get }
    // swiftlint:disable:next line_length
    /// This function should only be used as emergency option when something need to be custom once or twice or when something is really needed on production
    var customConfiguration: ((CommonCollection.ReusableView) -> Void)? { get set }
}

extension CommonCollection {
    open class ReusableView: UICollectionReusableView, Reusable, Loggable {
        public var identifier: String = ""
        public var section: Int?
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            configureViews()
        }
        
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        public required init?(coder: NSCoder) {
            fatalError("Not implemented")
        }
        
        open func bind(_ model: CommonCollectionReusableModel) {
            fatalError("Must override this function")
        }
        
        open func configureViews() {
        }
        
        deinit {
#if COMPONENT_SYSTEM_DBG
            logger.info("Deinitialized \(self)")
#endif
        }
    }
}
