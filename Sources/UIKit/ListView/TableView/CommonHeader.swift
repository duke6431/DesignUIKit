//
//  CommonHeader.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//

import UIKit

@objc public protocol CommonHeaderModel: NSObjectProtocol {
    var identifier: String { get }
    static var headerKind: CommonTableView.Header.Type { get }
    // swiftlint:disable:next line_length
    /// This function should only be used as emergency option when something need to be custom once or twice or when something is really needed on production
    var customConfiguration: ((CommonTableView.Header) -> Void)? { get set }
}

extension CommonTableView {
    @objc open class Header: UITableViewHeaderFooterView {
        public var identifier: String = ""
        public var section: Int?
        public override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configureViews()
        }
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        public required init?(coder: NSCoder) {
            fatalError("Not implemented")
        }
        
        open func bind(_ model: CommonHeaderModel) {
            fatalError("Must override this function")
        }
        
        open func configureViews() {
        }
    }
}
