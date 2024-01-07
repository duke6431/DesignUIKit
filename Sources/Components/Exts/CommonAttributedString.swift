//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 1/7/24.
//

import UIKit
import DesignCore

extension CommonAttributedString {
    public func background(with color: UIColor) -> Self {
        attributes[.backgroundColor] = color
        return self
    }
    
    public func foreground(with color: UIColor) -> Self {
        attributes[.foregroundColor] = color
        return self
    }
    public func font(with font: UIFont) -> Self {
        attributes[.font] = font
        return self
    }
}
