//
//  KeyboardComponents.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 24/05/2022.
//

import UIKit
import DesignCore

public class Key: KeyRenderable, KeyTappable {
    public enum Kind {
        case insert(value: String)
        case delete
    }

    public private(set) var multiplier = Keyboard.Multiplier()
    public var isBaseMeasurement = false
    weak var delegate: KeyTappableDelegate?

    var name: String { didSet { button.setTitle(name, for: .normal) } }
    var value: Kind
    var backgroundColor: UIColor = Keyboard.Default.Key.background { didSet { button.backgroundColor = backgroundColor } }
    var foregroundColor: UIColor = Keyboard.Default.Key.foreground { didSet { button.setTitleColor(foregroundColor, for: .normal) } }
    var font: UIFont = Keyboard.Default.Key.font { didSet { button.titleLabel?.font = font } }
    var cornerRadius: Double = 8 { didSet { button.layer.cornerRadius = cornerRadius } }
    var height: Double? {
        didSet {
            guard let height = height, height > 0 else { return }
            buttonHeightConstraint?.constant = height
            buttonHeightConstraint?.isActive = true
        }
    }
    var buttonHeightConstraint: NSLayoutConstraint?
    var shadow: CALayer.ShadowConfiguration = Keyboard.Default.Key.shadow {
        didSet { button.layer.removeShadow().addShadow(shadow) }
    }

    lazy var button: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    public init(name: String, value: Kind? = nil) {
        self.name = name
        if let value = value {
            self.value = value
        } else {
            self.value = .insert(value: name)
        }
    }

    func tap() { button.sendActions(for: .touchUpInside) }

    public func render() -> UIView {
        button.setTitle(name, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(foregroundColor, for: .normal)
        button.titleLabel?.font = font
        button.layer.cornerRadius = cornerRadius
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        buttonHeightConstraint = button.heightAnchor.constraint(equalToConstant: height ?? 1)
        if isBaseMeasurement { buttonHeightConstraint?.isActive = true }
        button.layer.removeShadow().addShadow(shadow)
        return button
    }

    @objc func tapped() { delegate?.didTap(action: value) }

    public func multiply(_ value: Keyboard.Multiplier) -> Self {
        self.multiplier = value
        return self
    }
}

public extension Key {
    func foreground(_ value: UIColor) -> Self {
        self.foregroundColor = value
        return self
    }
    func background(_ value: UIColor) -> Self {
        self.backgroundColor = value
        return self
    }
    func font(_ value: UIColor) -> Self {
        self.font = font
        return self
    }
    func base(withHeight height: Double) -> Self {
        self.isBaseMeasurement = true
        self.height = height
        return self
    }
    func shadow(_ value: CALayer.ShadowConfiguration) -> Self {
        self.shadow = value
        return self
    }
}

public class KeyStack: KeyRenderable {
    public lazy var multiplier: Keyboard.Multiplier = {
        var multiplier = keys.reduce(into: Keyboard.Multiplier(width: 0, height: 0)) {
            $0.width += $1.multiplier.width
            $0.height += $1.multiplier.height
        }
        axis == .horizontal ? (multiplier.height = 1) : (multiplier.width = 1)
        return multiplier
    }()
    weak var delegate: KeyTappableDelegate? {
        didSet {
            keys.forEach {
                if let stack = $0 as? KeyStack {
                    stack.delegate = self.delegate
                } else if let key = $0 as? Key {
                    key.delegate = self.delegate
                }
            }
        }
    }

    private var totalMultiplier: Double {
        axis == .horizontal ? multiplier.width : multiplier.height
    }
    var axis: NSLayoutConstraint.Axis = .horizontal
    let keys: [KeyRenderable]

    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.spacing = Keyboard.Default.spacing
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = axis
        return view
    }()

    public convenience init(@BuilderComponent<KeyRenderable> _ builder: () -> [KeyRenderable]) {
        self.init(keys: builder())
    }

    public init(keys: [KeyRenderable], axis: NSLayoutConstraint.Axis = .horizontal) {
        self.keys = keys
        self.axis = axis
    }

    public func render() -> UIView {
        var multipliers = [Keyboard.Multiplier]()
        keys.map {
            multipliers.append($0.multiplier)
            return $0.render()
        }.forEach(stackView.addArrangedSubview)
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            print("\(multipliers[index].current(axis))/\(totalMultiplier)")
            var constant = (multipliers.count > 1 ? -stackView.spacing / 2 : 0)
            if index != 0 && index != multipliers.count - 1 { constant *= 2 }
            switch axis {
            case .horizontal:
                view.widthAnchor.constraint(
                    equalTo: stackView.widthAnchor,
                    multiplier: multipliers[index].current(axis) / totalMultiplier,
                    constant: constant).isActive = true
            case .vertical:
                view.heightAnchor.constraint(
                    equalTo: stackView.heightAnchor,
                    multiplier: multipliers[index].current(axis) / totalMultiplier,
                    constant: constant).isActive = true
            @unknown default:
                fatalError("Not implemented")
            }
        }
        return stackView
    }

    public func multiply(_ value: Keyboard.Multiplier) -> Self {
        multiplier = value
        return self
    }

    public func axis(_ axis: NSLayoutConstraint.Axis = .horizontal) -> Self {
        self.axis = axis
        return self
    }
}
