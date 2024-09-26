//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import DesignCore
import Combine

open class BaseView: BView, FConfigurable, Combinable, FThemableBackground, FThemableShadow {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
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
}

open class BaseStackView: BStackView, FConfigurable, Combinable, FThemableBackground, FThemableShadow {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
    public convenience init(arrangedSubviews views: [BView]) {
        self.init(frame: .zero)
        views.forEach(addArrangedSubview)
        loadConfiguration()
    }
    
    @available(*, unavailable)
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        loadConfiguration()
    }
    
    open override func addArrangedSubview(_ view: BView) {
        view.configuration?.shouldConstraintWithParent = false
        super.addArrangedSubview(view)
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

open class BaseScrollView: BScrollView, FConfigurable, Combinable, FThemableBackground, FThemableShadow {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        loadConfiguration()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    open override func addSubview(_ view: BView) {
        view.configuration?.shouldConstraintWithParent = false
        super.addSubview(view)
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

open class BaseImageView: BImageView, FConfigurable, Combinable, FThemableBackground, FThemableShadow {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        loadConfiguration()
    }
    
    public override init(image: BImage?) {
        super.init(image: image)
        loadConfiguration()
    }
    
    public override init(image: BImage?, highlightedImage: BImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        loadConfiguration()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
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

open class BaseButton: BButton, FConfigurable, Combinable, FThemableBackground, FThemableShadow {
    public var cancellables = Set<AnyCancellable>()
    
    public convenience init(style buttonType: BButton.ButtonType? = nil) {
        self.init(type: buttonType ?? .system)
        loadConfiguration()
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

open class BaseLabel: BLabel, FConfigurable, Combinable, FThemableBackground, FThemableShadow {
    var contentInsets: BEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
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
}

open class BaseTextField: BTextField, FConfigurable, Combinable, FThemableBackground, FThemableShadow {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
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

open class BaseTextView: BTextView, FConfigurable, Combinable, FThemableBackground, FThemableShadow {
    public var cancellables = Set<AnyCancellable>()
    
    public init(frame: CGRect = .zero) {
        super.init(frame: frame, textContainer: nil)
        loadConfiguration()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
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
