//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 3/21/24.
//

import UIKit

/// Unification of View
public typealias BView = UIView
/// Unification of Label
public typealias BLabel = UILabel
/// Unification of TextField
public typealias BTextField = UITextField
/// Unification of TextView
public typealias BTextView = UITextView
/// Unification of Button
public typealias BButton = UIButton
/// Unification of ScrollView
public typealias BScrollView = UIScrollView
/// Unification of StackView
public typealias BStackView = UIStackView
/// Unification of ImageView
public typealias BImageView = UIImageView

public extension BView {
    var owningViewController: UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.owningViewController
        } else {
            return nil
        }
    }
}
