//
//  CommonTextFieldDemo.swift
//  Catalog
//
//  Created by Duc IT. Nguyen Minh on 25/05/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import DesignComponents
import DesignRx

class CommonTextFieldVC: UIViewController {
    var disposeBag = DisposeBag()
    lazy var textField: CommonTextField = {
        let view = CommonTextField()
        view.borderWidth = 1
        view.borderColor = .lightGray
        view.cornerRadius = 8
        view.icon = UIImage(systemName: "magnifyingglass.circle.fill")?.tint(with: .lightGray)
        self.view.addSubview(view)
        Keyboard.numberPadWithReturn.attach(to: view.textField)
        return view
    }()
    lazy var clearButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        return view
    }()
    lazy var toggle: UISwitch =  {
        let view = UISwitch()
        view.rx.value.bind { [weak self] status in
            guard let self = self else { return }
            status ? self.textField.trailingView.addSubview(self.clearButton) : self.clearButton.removeFromSuperview()
            if status {
                self.clearButton.snp.makeConstraints {
                    $0.edges.equalToSuperview().inset(6)
                }
            }
        }.disposed(by: disposeBag)
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
        toggle.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(8)
            $0.leading.equalTo(textField)
        }
        toggleLabel.snp.makeConstraints {
            $0.centerY.equalTo(toggle)
            $0.leading.equalTo(toggle.snp.trailing).offset(8)
            $0.trailing.equalTo(textField)
        }
    }
}
