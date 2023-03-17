//
//  TextFieldDelegateProxy.swift
//  
//
//  Created by Duc Minh Nguyen on 5/17/22.
//

import UIKit

public class TextFieldDelegateProxy: NSObject, UITextFieldDelegate {
    weak var owner: UITextField? {
        didSet {
            owner?.delegate = self
        }
    }
    var textFieldDidChange: ((UITextField) -> Void)?
    public var validator: [Validator] = []

    required init(owner: UITextField? = nil) {
        super.init()
        self.owner = owner
        self.owner?.delegate = self
    }

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return true
    }
}
