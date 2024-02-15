//
//  CommonTextFieldDemo.swift
//  Catalog
//
//  Created by Duc IT. Nguyen Minh on 25/05/2022.
//

import UIKit
import SnapKit
import DesignUIKit
//import DesignRx

class CommonTextFieldVC: UIViewController {
//    var disposeBag = DisposeBag()
    lazy var textfield: CommonTextField = {
        let view = CommonTextField()
        view.borderWidth = 1
        view.borderColor = .lightGray
        view.cornerRadius = 8
        view.icon = UIImage(systemName: "magnifyingglass.circle.fill")?.withTintColor(.lightGray)
        self.view.addSubview(view)
        Keyboard.numberPadWithReturn.attach(to: view.textField)
        return view
    }()
    lazy var clearButton: UIButton = {
        let view = UIButton()
        view.tintColor = .lightGray
        view.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
//        view.rx.tap.bind(to: Binder(self, binding: { target, _ in
//            target.textfield.text = nil
//        })).disposed(by: disposeBag)
        return view
    }()
    lazy var toggle: UISwitch =  {
        let view = UISwitch()
//        view.rx.value.bind { [weak self] status in
//            guard let self = self else { return }
//            status ? self.textfield.trailingView.addSubview(self.clearButton) : self.clearButton.removeFromSuperview()
//            if status {
//                self.clearButton.snp.makeConstraints {
//                    $0.edges.equalToSuperview().inset(6)
//                    $0.width.equalTo(self.clearButton.snp.height)
//                }
//            }
//        }.disposed(by: disposeBag)
        self.view.addSubview(view)
        return view
    }()
    lazy var fieldLabel: UILabel = {
        let view = UILabel()
        view.text = "Amount"
        self.view.addSubview(view)
        return view
    }()
    lazy var toggleLabel: UILabel = {
        let view = UILabel()
        view.text = "Add clear button"
        self.view.addSubview(view)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
        textfield.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            $0.leading.equalToSuperview().offset(20)
        }
        fieldLabel.snp.makeConstraints {
            $0.leading.equalTo(textfield)
            $0.bottom.equalTo(textfield.snp.top).offset(-4)
            $0.trailing.lessThanOrEqualTo(textfield)
        }
        toggle.snp.makeConstraints {
            $0.top.equalTo(textfield.snp.bottom).offset(8)
            $0.leading.equalTo(textfield)
        }
        toggleLabel.snp.makeConstraints {
            $0.centerY.equalTo(toggle)
            $0.leading.equalTo(toggle.snp.trailing).offset(8)
            $0.trailing.equalTo(textfield)
        }
    }
}
