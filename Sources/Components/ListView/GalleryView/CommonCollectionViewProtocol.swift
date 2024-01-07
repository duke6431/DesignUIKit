//
//  CommonCollectionViewProtocol.swift
//  DesignKit
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//

import DesignCore
import UIKit
#if canImport(DesignToolbox)
import DesignToolbox
#endif

@objc public protocol CommonSlidingViewDelegate: AnyObject {
    @objc optional func didSelectCell(at indexPath: IndexPath, with data: CommonCollectionCellModel)
}

public class CommonCollection {

}
