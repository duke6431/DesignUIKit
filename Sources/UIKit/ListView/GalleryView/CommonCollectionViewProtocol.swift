//
//  CommonCollectionViewProtocol.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//

import DesignCore
import UIKit

@objc public protocol CommonSlidingViewDelegate: AnyObject {
    @objc optional func didSelectCell(at indexPath: IndexPath, with data: CommonCollectionCellModel)
}

public class CommonCollection { }
