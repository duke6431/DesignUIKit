//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import Combine

open class BaseView: UIView, Combinable {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    open func loadConfiguration() {
        configuration = .init()
    }
}

open class BaseStackView: UIStackView, Combinable {
    public var cancellables = Set<AnyCancellable>()
    
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
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        loadConfiguration()
    }
    
    open override func addArrangedSubview(_ view: UIView) {
        view.configuration?.shouldConstraintWithParent = false
        super.addArrangedSubview(view)
    }
    
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
}

open class BaseScrollView: UIScrollView, Combinable {
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        loadConfiguration()
    }
    
    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open override func addSubview(_ view: UIView) {
        view.configuration?.shouldConstraintWithParent = false
        super.addSubview(view)
    }
    
    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
}

open class BaseImageView: UIImageView, Combinable {
    public var cancellables = Set<AnyCancellable>()
    
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
    public required init?(coder: NSCoder) {
        fatalError()
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
}

open class BaseButton: UIButton, Combinable {
    public var cancellables = Set<AnyCancellable>()
    
    public convenience init(style buttonType: UIButton.ButtonType) {
        self.init(type: buttonType)
        loadConfiguration()
    }

    open func loadConfiguration() {
        configuration = .init()
        configuration?.owner = self
    }
}

open class BaseLabel: UILabel, Combinable {
    var contentInsets: UIEdgeInsets = .zero
    
    public var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadConfiguration()
    }
    
    @available(iOS, unavailable)
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
}
