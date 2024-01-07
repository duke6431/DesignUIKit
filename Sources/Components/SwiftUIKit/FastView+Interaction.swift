//
//  FastView+Interaction.swift
//  DesignKit
//
//  Created by Duc IT. Nguyen Minh on 12/09/2023.
//

import UIKit
import DesignCore
import DesignToolbox

public class QButton: UIButton, ViewBuildable {
    var actionId: String?
    var customConfiguration: ((UIButton) -> Void)?
    public var onTap: (() -> Void)? {
        didSet {
            try? removeAction(for: .touchUpInside, identifier: actionId)
            if let onTap {
                actionId = addAction(for: .touchUpInside, onTap)
            }
        }
    }

    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Unavailable")
    }

    public init(text: String, font: UIFont = FontSystem.font(with: .body), color: UIColor = .systemBlue,
                contentHuggingV: UILayoutPriority = .defaultLow,
                contentHuggingH: UILayoutPriority = .defaultLow,
                compressionResistanceV: UILayoutPriority = .defaultHigh,
                compressionResistanceH: UILayoutPriority = .defaultHigh,
                onTap: (() -> Void)? = nil, customConfiguration: ((UIButton) -> Void)? = nil) {
        super.init(frame: .zero)
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(color, for: .normal)
        self.setContentHuggingPriority(contentHuggingV, for: .vertical)
        self.setContentHuggingPriority(contentHuggingH, for: .horizontal)
        self.setContentCompressionResistancePriority(compressionResistanceV, for: .vertical)
        self.setContentCompressionResistancePriority(compressionResistanceH, for: .horizontal)
        self.onTap = onTap
        self.customConfiguration = customConfiguration
    }

    public init(@ViewBuilder _ content: () -> [ViewBuildable],
                onTap: (() -> Void)? = nil,
                customConfiguration: ((UIButton) -> Void)? = nil) {
        super.init(frame: .zero)
        let content = QStack.Z(content).with(\.isUserInteractionEnabled, setTo: false).body
        self.addSubview(content)
        NSLayoutConstraint.activate {
            content.topAnchor.constraint(equalTo: topAnchor)
            content.bottomAnchor.constraint(equalTo: bottomAnchor)
            content.leadingAnchor.constraint(equalTo: leadingAnchor)
            content.trailingAnchor.constraint(equalTo: trailingAnchor)
        }
        self.onTap = onTap
        self.customConfiguration = customConfiguration
    }

    public func configureViews() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        customConfiguration?(self)
    }
}

public class QTextField: UITextField, ViewBuildable {
    class DelegateProxy: NSObject, UITextFieldDelegate {
        weak var owner: UITextField? {
            didSet {
                owner?.delegate = self
            }
        }
        var textFieldDidChange: ((UITextField) -> Void)?
        var textFieldDidReturn: ((UITextField) -> Void)?

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

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard let owner = owner else { return true }
            textFieldDidReturn?(owner)
            return true
        }
    }

    var delegateProxy: DelegateProxy?
    public var onChanged: ((String) -> Void)?
    public var onReturned: ((String) -> Void)?
    var customConfiguration: ((UITextField) -> Void)?

    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Unavailable")
    }

    public init(placeholder: String, font: UIFont = FontSystem.font(with: .body),
                textColor: UIColor = .black,
                customConfiguration: ((UITextField) -> Void)? = nil,
                _ onChanged: ((String) -> Void)? = nil,
                _ onReturned: ((String) -> Void)? = nil) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.font = font
        self.customConfiguration = customConfiguration
    }

    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false
        delegateProxy = .init(owner: self)
        delegateProxy?.textFieldDidChange = { [weak self] in
            self?.onChanged?($0.text ?? "")
        }
        delegateProxy?.textFieldDidReturn = { [weak self] in
            self?.onReturned?($0.text ?? "")
        }
    }
}
