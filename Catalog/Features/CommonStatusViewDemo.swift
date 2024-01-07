//
//  CommonStatusViewDemo.swift
//  Catalog
//
//  Created by Duc IT. Nguyen Minh on 06/03/2023.
//

import UIKit
import SnapKit
import DesignKit

class CommonStatusViewVC: UIViewController {
    lazy var statusView: CommonStatusView = {
        let view = CommonStatusView()
        view.image = .init(systemName: "trash.circle")?.withRenderingMode(.alwaysTemplate)
        view.title = "Taking the trash out here"
        view.subtitle = "This is just a description! So let's goooooooooo..."
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(statusView)
        statusView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(3.0 / 4)
        }
    }
}
