//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 3/21/24.
//

#if canImport(UIKit)
import UIKit

public typealias BView = UIView
public typealias BLabel = UILabel
public typealias BTextField = UITextField
public typealias BButton = UIButton
public typealias BScrollView = UIScrollView
public typealias BStackView = UIStackView
public typealias BImageView = UIImageView
#else
import AppKit

public typealias BView = NSView
public typealias BTextField = NSTextField
public typealias BButton = NSButton
public typealias BScrollView = NSScrollView
public typealias BStackView = NSStackView
public typealias BImageView = NSImageView

open class BLabel: BTextField {
    public override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      self.isBezeled = false
      self.drawsBackground = false
      self.isEditable = false
      self.isSelectable = false
    }
    
    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
}

public extension BTextField {
    var text: String {
        get { stringValue }
        set { stringValue = newValue }
    }
    var attributedText: NSAttributedString {
        get { attributedStringValue }
        set { attributedStringValue = newValue }
    }
    var placeholder: String? {
        get { placeholderString }
        set { placeholderString = newValue }
    }
}
#endif
