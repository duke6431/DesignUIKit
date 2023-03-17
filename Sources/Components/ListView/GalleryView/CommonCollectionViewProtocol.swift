//
//  CommonCollectionViewProtocol.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//

import DesignCore
import UIKit
#if canImport(DesignToolbox)
import DesignToolbox
#endif

public typealias CommonCollectionConfigPair = (model: CommonCollectionCellModel.Type, cell: CommonCollection.Cell.Type)
// swiftlint:disable:next line_length
public typealias CommonCollectionHeaderConfigPair = (model: CommonCollectionReusableModel.Type, header: CommonCollection.ReusableView.Type)

@objc public protocol CommonSlidingViewDelegate: AnyObject {
    @objc optional func didSelectCell(at indexPath: IndexPath, with data: CommonCollectionCellModel)
}

public class CommonCollection {

}
