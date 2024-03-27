//
//  CommonCollectionViewProtocol.swift
//  DesignComponents
//
//  Created by Duc IT. Nguyen Minh on 13/03/2023.
//

import DesignCore
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

@objc public protocol CommonCollectionViewDelegate: AnyObject {
    @objc optional func didSelectCell(at indexPath: IndexPath, with data: CommonCollectionCellModel)
}

public class CommonCollection { }
