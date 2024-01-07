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
    public var validators: [Validator] = []

    required init(owner: UITextField? = nil) {
        super.init()
        self.owner = owner
        self.owner?.delegate = self
        self.owner?.addTarget(self, action: #selector(textFieldValueChanged), for: .valueChanged)
    }

    @objc func textFieldValueChanged() {
        guard let owner = owner else { return }
        textFieldDidChange?(owner)
    }

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""

        guard let range = Range(range, in: currentText) else { return false }
        let newText = currentText.replacingCharacters(in: range, with: string)

        return validators.first { !((try? $0.validate(newText))?.status ?? false) && $0.ruleType == .live } != nil
    }
}
