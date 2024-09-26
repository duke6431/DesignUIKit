//
//  CommonTableViewProtocol.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//

import UIKit

@objc public protocol CommonTableViewDelegate: AnyObject {
    @objc optional func refreshStarted()
    @objc optional func didSelectCell(at indexPath: IndexPath, with data: CommonCellModel)
    @objc optional func loadMore()
}

public class CommonTableSection {
    public var header: CommonHeaderModel?
    public var items: [CommonCellModel]

    public init(header: CommonHeaderModel? = nil, items: [CommonCellModel]) {
        self.header = header
        self.items = items
    }
}
