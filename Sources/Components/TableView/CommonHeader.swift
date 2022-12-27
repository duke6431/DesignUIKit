//
//  CommonHeader.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//

import UIKit
#if canImport(DesignToolbox)
import DesignToolbox
#endif

@objc public protocol CommonHeaderModel: NSObjectProtocol {
    var identifier: String { get }
    /// This function should only be used as emergency option when something need to be custom once or twice or when something is really needed on production
    var customConfigurartion: ((CommonHeader) -> Void)? { get set }
}

@objc open class CommonHeader: UITableViewHeaderFooterView {
#if canImport(DesignToolbox)
    weak public var currentTheme: Theme?
#endif
    public var identifier: String = ""
    public var section: Int?
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    open func bind(_ model: CommonHeaderModel) {
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
extension CommonHeader: Themable { }
#endif
