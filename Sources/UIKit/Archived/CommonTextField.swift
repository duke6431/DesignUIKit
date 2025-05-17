//
//  CommonTextField.swift
//  Components
//
//  Created by Duke Nguyen on 25/05/2022.
//
import UIKit
import DesignCore

@objc public protocol CommonTextFieldDelegate: UITextFieldDelegate {
    @objc optional func textFieldDidChange(_ textField: UITextField)
}

/*
 CommonTextField layout:
 ._____.____________._____.
 |     |            |     |
 |icon-4-text field-4-btn?|
 ._____!____________!_____!
 Button/View at the end, optional since it will attach to edges with no spacing
 Icon at the head and will attach to edges in a customizable way(spacing)
 Text field will filling the rest.
 Textfield have fixed height => the only thing that's ambiguous while using constraint is width of the field
 */
public class CommonTextField: UIView {
    public struct Default {
        public struct Icon {
            public static var height: CGFloat = 24
            public static var leadingConstant: CGFloat = 6
        }
        public static var height: CGFloat = 36
        public static var borderWidth: Double = .zero
        public static var borderColor: UIColor = .clear
        public static var cornerRadius: Double = .zero
    }

    // MARK: Configuration
    /// The `iconEdgeInset` property will not have any effect if there icon is not selected
    public var iconEdgeInset: UIEdgeInsets = .zero
    public var borderWidth: Double = Default.borderWidth { didSet { updateBorder() } }
    public var borderColor: UIColor = Default.borderColor { didSet { updateBorder() } }
    public var cornerRadius: Double = Default.cornerRadius { didSet { updateBorder() } }

    // MARK: Content
    public weak var delegate: CommonTextFieldDelegate?
    public var icon: UIImage? {
        didSet {
            revalidateConstraint()
            iconView.image = icon
        }
    }
    public var inputKeyboard: UIView? { didSet { textField.inputView = inputView } }
    public override var inputView: UIView? {
        get { inputKeyboard }
        set { inputKeyboard = newValue }
    }

    // MARK: Properties
    public override var isFirstResponder: Bool { return textField.isFirstResponder }
    public override var canBecomeFirstResponder: Bool { return textField.canBecomeFirstResponder }
    public var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    // MARK: Private properties
    private var iconWidth: NSLayoutConstraint?
    private var textFieldLeading: NSLayoutConstraint?
    private var trailingViewWidth: NSLayoutConstraint?
    // MARK: Components
    public private(set) lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public private(set) lazy var textField: UITextField = {
        let view = UITextField()
        view.addTarget(self, action: #selector(textFieldDidChange), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public private(set) lazy var trailingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureViews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    func configureViews() {
        clipsToBounds = true
        layoutAndConfigureConstraint()
    }

    func updateBorder() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = CGFloat(borderWidth)
        layer.cornerRadius = CGFloat(cornerRadius)
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK: - Configure and construction
extension CommonTextField {
    fileprivate func layoutAndConfigureConstraint() {
        [iconView, textField, trailingView].forEach(addSubview)
        // TextField leading on if no image and off if there is an image
        textFieldLeading = textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        trailingViewWidth = trailingView.widthAnchor.constraint(equalToConstant: 0)
        trailingViewWidth?.priority = .defaultHigh + 50
        iconWidth = iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor)
        NSLayoutConstraint.activate {
            textFieldLeading!
            trailingViewWidth!
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Default.Icon.leadingConstant)
            iconView.heightAnchor.constraint(equalToConstant: Default.Icon.height)
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
            textField.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 4)
            textField.topAnchor.constraint(equalTo: topAnchor)
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
            textField.heightAnchor.constraint(equalToConstant: Default.height)
            trailingView.topAnchor.constraint(equalTo: topAnchor)
            trailingView.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8)
            trailingView.trailingAnchor.constraint(equalTo: trailingAnchor)
            trailingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
    }
    fileprivate func revalidateConstraint() {
        if icon != nil {
            textFieldLeading?.isActive = false
            iconWidth?.isActive = true
        } else {
            textFieldLeading?.isActive = true
            iconWidth?.isActive = false
        }
    }
}

// MARK: - Builder
extension CommonTextField {
    public func border(width: Double = .zero, color: UIColor) -> Self {
        self.borderWidth = width
        self.borderColor = color
        return self
    }
    public func cornerRadius(_ value: Double = .zero) -> Self {
        self.cornerRadius = value
        return self
    }
}

// MARK: - Delegate
extension CommonTextField: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        delegate?.textFieldDidChange?(textField)
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldClear?(textField) ?? true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldReturn?(textField) ?? true
    }

    // swiftlint:disable:next line_length
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
}
