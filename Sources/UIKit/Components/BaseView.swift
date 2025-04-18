//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import DesignCore

open class BaseView: UIView, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }

    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }

    open func loadConfiguration() {
        configuration = .init()
    }

    public var backgroundKey: ThemeKey?
    public var shadowKey: ThemeKey?
    open func apply(theme: ThemeProvider) {
        if let backgroundKey {
            configuration?.backgroundColor = theme.color(key: backgroundKey)
            backgroundColor = theme.color(key: backgroundKey)
        }
        if let shadowKey {
            configuration?.shadow = configuration?.shadow?.custom {
                $0.color = theme.color(key: shadowKey)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    deinit {
        logger.trace("Deinitialized \(self)")
    }
}

open class BaseStackView: UIStackView, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }

    public convenience init(arrangedSubviews views: [UIView]) {
        self.init(frame: .zero)
        views.forEach(addArrangedSubview)
        loadConfiguration()
    }

    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        loadConfiguration()
    }

    open override func addArrangedSubview(_ view: UIView) {
        view.configuration?.shouldConstraintWithParent = false
        super.addArrangedSubview(view)
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }

    public var backgroundKey: ThemeKey?
    public var shadowKey: ThemeKey?
    open func apply(theme: ThemeProvider) {
        if let backgroundKey {
            configuration?.backgroundColor = theme.color(key: backgroundKey)
            backgroundColor = theme.color(key: backgroundKey)
        }
        if let shadowKey {
            configuration?.shadow = configuration?.shadow?.custom {
                $0.color = theme.color(key: shadowKey)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    deinit {
        logger.trace("Deinitialized \(self)")
    }
}

open class BaseScrollView: UIScrollView, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        loadConfiguration()
    }

    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open override func addSubview(_ view: UIView) {
        view.configuration?.shouldConstraintWithParent = false
        super.addSubview(view)
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }

    public var backgroundKey: ThemeKey?
    public var shadowKey: ThemeKey?
    open func apply(theme: ThemeProvider) {
        if let backgroundKey {
            configuration?.backgroundColor = theme.color(key: backgroundKey)
            backgroundColor = theme.color(key: backgroundKey)
        }
        if let shadowKey {
            configuration?.shadow = configuration?.shadow?.custom {
                $0.color = theme.color(key: shadowKey)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    deinit {
        logger.trace("Deinitialized \(self)")
    }
}

open class BaseImageView: UIImageView, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        loadConfiguration()
    }

    public override init(image: UIImage?) {
        super.init(image: image)
        loadConfiguration()
    }

    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        loadConfiguration()
    }

    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }

    public var backgroundKey: ThemeKey?
    public var shadowKey: ThemeKey?
    open func apply(theme: ThemeProvider) {
        if let backgroundKey {
            configuration?.backgroundColor = theme.color(key: backgroundKey)
            backgroundColor = theme.color(key: backgroundKey)
        }
        if let shadowKey {
            configuration?.shadow = configuration?.shadow?.custom {
                $0.color = theme.color(key: shadowKey)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    deinit {
        logger.trace("Deinitialized \(self)")
    }
}

open class BaseButton: UIButton, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    public convenience init(style buttonType: UIButton.ButtonType? = nil) {
        self.init(type: buttonType ?? .custom)
        loadConfiguration()
    }

    open override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.alpha = (self?.isHighlighted ?? false) ? 0.35 : 1
            }
        }
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }

    public var backgroundKey: ThemeKey?
    public var shadowKey: ThemeKey?
    open func apply(theme: ThemeProvider) {
        if let backgroundKey {
            configuration?.backgroundColor = theme.color(key: backgroundKey)
            backgroundColor = theme.color(key: backgroundKey)
        }
        if let shadowKey {
            configuration?.shadow = configuration?.shadow?.custom {
                $0.color = theme.color(key: shadowKey)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
}

open class BaseLabel: UILabel, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    var contentInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }

    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }

    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }

    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInsets.left + contentInsets.right,
                      height: size.height + contentInsets.top + contentInsets.bottom)
    }

    open override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (contentInsets.left + contentInsets.right)
        }
    }

    public var backgroundKey: ThemeKey?
    public var shadowKey: ThemeKey?
    open func apply(theme: ThemeProvider) {
        if let backgroundKey {
            configuration?.backgroundColor = theme.color(key: backgroundKey)
            backgroundColor = theme.color(key: backgroundKey)
        }
        if let shadowKey {
            configuration?.shadow = configuration?.shadow?.custom {
                $0.color = theme.color(key: shadowKey)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    deinit {
        logger.trace("Deinitialized \(self)")
    }
}

open class BaseTextField: UITextField, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }

    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }

    public var backgroundKey: ThemeKey?
    public var shadowKey: ThemeKey?
    open func apply(theme: ThemeProvider) {
        if let backgroundKey {
            configuration?.backgroundColor = theme.color(key: backgroundKey)
            backgroundColor = theme.color(key: backgroundKey)
        }
        if let shadowKey {
            configuration?.shadow = configuration?.shadow?.custom {
                $0.color = theme.color(key: shadowKey)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    deinit {
        logger.trace("Deinitialized \(self)")
    }
}

open class BaseTextView: UITextView, FConfigurable, FThemableBackground, FThemableShadow, Loggable {
    public init(frame: CGRect = .zero) {
        super.init(frame: frame, textContainer: nil)
        loadConfiguration()
    }

    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configuration?.willMove(toSuperview: newSuperview)
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }

    public var backgroundKey: ThemeKey?
    public var shadowKey: ThemeKey?
    open func apply(theme: ThemeProvider) {
        if let backgroundKey {
            configuration?.backgroundColor = theme.color(key: backgroundKey)
            backgroundColor = theme.color(key: backgroundKey)
        }
        if let shadowKey {
            configuration?.shadow = configuration?.shadow?.custom {
                $0.color = theme.color(key: shadowKey)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    deinit {
        logger.trace("Deinitialized \(self)")
    }
}
