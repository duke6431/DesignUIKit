//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 3/21/24.
//

#if canImport(UIKit)
import UIKit

/// Unification of ViewController
public typealias BViewController = UIViewController
#else
import AppKit

public typealias BViewController = NSViewController
#endif
