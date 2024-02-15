//
//  KeyboardDemo.swift
//  Catalog
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//

import UIKit
import DesignUIKit
import SnapKit

class KeyboardVC: UIViewController {
    lazy var textField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        self.view.addSubview(view)
        return view
    }()
    lazy var fieldLabel: UILabel = {
        let view = UILabel()
        view.text = "Amount"
        self.view.addSubview(view)
        return view
    }()
    lazy var keyboard: Keyboard = {
        Keyboard.Default.outerSpacing.bottom = 12 + 20
        Keyboard.Default.Key.shadow = CALayer.ShadowConfiguration()
        let view = Keyboard.numberPadWithReturn
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
        textField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            $0.leading.equalToSuperview().offset(20)
        }
        fieldLabel.snp.makeConstraints {
            $0.leading.equalTo(textField)
            $0.bottom.equalTo(textField.snp.top).offset(-4)
            $0.trailing.lessThanOrEqualTo(textField)
        }
        keyboard.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view)
        }
        keyboard.attach(to: textField)
    }
}
