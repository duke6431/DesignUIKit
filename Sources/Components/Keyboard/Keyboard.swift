//
//  Keyboard.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 21/05/2022.
//

import UIKit

public class Keyboard: UIInputView {
    @available(iOS 13.0, *)
    public static var numberPadWithReturn: Keyboard {
        Keyboard(stack: KeyStack {
            KeyStack {
                KeyStack(keys: Array(1...3).map { Key(name: "\($0)") })
                KeyStack(keys: Array(4...6).map { Key(name: "\($0)") })
                KeyStack(keys: Array(7...9).map { Key(name: "\($0)") })
                KeyStack {
                    Key(name: "0").base(withHeight: 44)
//                    Key(name: ".")
                    Key(name: "000").multiply(.init(width: 2, height: 1))
                }
            }.axis(.vertical).multiply(.init(width: 3, height: 4))
            KeyStack {
                Key(name: "Del", image: .init(systemName: "delete.left"), value: .delete)
                Key(name: "Enter", value: .insert(value: "\n")).background(.systemBlue).foreground(.white)
            }.axis(.vertical)
        })
    }

    public struct Multiplier {
        public var width: Double = 1
        public var height: Double = 1

        public init(width: Double = 1, height: Double = 1) {
            self.width = width
            self.height = height
        }

        func current(_ axis: NSLayoutConstraint.Axis) -> Double {
            axis == .horizontal ? width : height
        }
    }

    var stack: KeyRenderable
    weak var textField: UITextField?

    public init(stack: KeyRenderable) {
        self.stack = stack
        super.init(frame: .zero, inputViewStyle: .keyboard)
        if let stack = self.stack as? KeyStack {
            stack.delegate = self
        } else if let stack = self.stack as? Key {
            stack.delegate = self
        }
        configureViews()
    }
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    public func attach(to textField: UITextField?) {
        self.textField = textField
        textField?.inputView = self
    }

    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Default.keyboardBackground
        let renderedStack = stack.render()
        addSubview(renderedStack)
        NSLayoutConstraint.activate([
            renderedStack.topAnchor.constraint(
                equalTo: topAnchor, constant: Keyboard.Default.outerSpacing.top
            ),
            renderedStack.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: Keyboard.Default.outerSpacing.left
            ),
            renderedStack.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -Keyboard.Default.outerSpacing.right
            ),
            renderedStack.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -Keyboard.Default.outerSpacing.bottom
            )
        ])
    }
}

extension Keyboard: KeyTappableDelegate {
    func didTap(action: Key.Kind) {
        switch action {
        case .insert(let value):
            textField?.insertText(value)
        case .delete:
            textField?.deleteBackward()
        }
    }
}
