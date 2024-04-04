//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import DesignCore
import Combine

open class BaseView: BView, Combinable, FThemableBackground {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
#if canImport(UIKit)
    @available(iOS, unavailable)
#else
    @available(macOS, unavailable)
#endif
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    open func loadConfiguration() {
        configuration = .init()
    }
    
    public var backgroundKey: ThemeKey?
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        configuration?.backgroundColor = theme.color(key: backgroundKey)
        backgroundColor = theme.color(key: backgroundKey)
    }
}

open class BaseStackView: BStackView, Combinable, FThemableBackground {
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

#if canImport(UIKit)
    @available(iOS, unavailable)
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        loadConfiguration()
    }
#else
    @available(macOS, unavailable)
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        loadConfiguration()
    }
#endif
    
    open override func addArrangedSubview(_ view: BView) {
        view.configuration?.shouldConstraintWithParent = false
        super.addArrangedSubview(view)
    }
    
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    public var backgroundKey: ThemeKey?
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        configuration?.backgroundColor = theme.color(key: backgroundKey)
        backgroundColor = theme.color(key: backgroundKey)
    }
}

open class BaseScrollView: BScrollView, Combinable, FThemableBackground {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        loadConfiguration()
    }
    
#if canImport(UIKit)
    @available(iOS, unavailable)
#else
    @available(macOS, unavailable)
#endif
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
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        configuration?.backgroundColor = theme.color(key: backgroundKey)
        backgroundColor = theme.color(key: backgroundKey)
    }
}

open class BaseImageView: BImageView, Combinable, FThemableBackground {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        loadConfiguration()
    }
    
    #if canImport(UIKit)
    public override init(image: BImage?) {
        super.init(image: image)
        loadConfiguration()
    }
    
    public override init(image: BImage?, highlightedImage: BImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        loadConfiguration()
    }
    #else
    public init(image: BImage? = nil) {
        super.init(frame: .zero)
        self.image = image
        loadConfiguration()
    }
    #endif
    
#if canImport(UIKit)
    @available(iOS, unavailable)
#else
    @available(macOS, unavailable)
#endif
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    public var backgroundKey: ThemeKey?
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        configuration?.backgroundColor = theme.color(key: backgroundKey)
        backgroundColor = theme.color(key: backgroundKey)
    }
}

open class BaseButton: BButton, Combinable, FThemableBackground {
    public var cancellables = Set<AnyCancellable>()
    
    public convenience init(style buttonType: BButton.ButtonType? = nil) {
        #if canImport(UIKit)
        self.init(type: buttonType ?? .system)
        #else
        self.init(frame: .zero)
        if let buttonType {
            self.setButtonType(buttonType)
        }
        #endif
        loadConfiguration()
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    public var backgroundKey: ThemeKey?
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        configuration?.backgroundColor = theme.color(key: backgroundKey)
        backgroundColor = theme.color(key: backgroundKey)
    }
}

open class BaseLabel: BLabel, Combinable, FThemableBackground {
    var contentInsets: BEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
#if canImport(UIKit)
    @available(iOS, unavailable)
#else
    @available(macOS, unavailable)
#endif
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    #if canImport(UIKit)
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }
    #endif
    
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
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        configuration?.backgroundColor = theme.color(key: backgroundKey)
        backgroundColor = theme.color(key: backgroundKey)
    }
}

open class BaseTextField: BTextField, Combinable, FThemableBackground {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
#if canImport(UIKit)
    @available(iOS, unavailable)
#else
    @available(macOS, unavailable)
#endif
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
    
    public var backgroundKey: ThemeKey?
    public func apply(theme: ThemeProvider) {
        guard let backgroundKey else { return }
        configuration?.backgroundColor = theme.color(key: backgroundKey)
        backgroundColor = theme.color(key: backgroundKey)
    }
}
