//
//  FSwitch.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/16.
//
//  A customizable toggle switch component with support for colored or image-based states,
//  tap/swipe gestures, and fluent-style configuration.
//

import UIKit
import SnapKit
import DesignCore

/// A customizable toggle switch view with support for colored or image-based state indicators.
/// Supports interaction via tap and swipe gestures and allows runtime configuration.
public final class FSwitch: BaseView, FComponent {
    /// An optional closure to perform additional custom configuration on the switch.
    public var customConfiguration: ((FSwitch) -> Void)?
    
    /// Indicates whether the switch is currently on. Triggers UI update on change.
    public var isOn: Bool = false { didSet { set(on: isOn) } }
    
    /// Optional customization for thumb image.
    public var thumbImage: UIImage?
    /// Background color of the thumb view.
    public var thumUIColor: UIColor = .white
    /// Background color of the switch when off.
    public var statusColorOff: UIColor = .white
    /// Background color of the switch when on.
    public var statusColorOn: UIColor = .systemGreen
    /// Image displayed when the switch is off.
    public var statusImageOff: UIImage?
    /// Image displayed when the switch is on.
    public var statusImageOn: UIImage?
    
    private var onSwitch: ((Bool) -> Void)?
    
    private weak var statusImage: UIImageView?
    private var thumbViewLeading: Constraint?
    private var thumbViewTrailing: Constraint?
    private lazy var thumbView: UIView = {
        let view = FZStack {
            if let thumbImage {
                FImage(image: thumbImage).contentMode(.scaleAspectFill)
            }
        }.background(thumUIColor).shaped(.circle).customized {
            $0.configuration?.shouldConstraintWithParent = false
        }.shadow(.init(opacity: 0.4, radius: 3))
        return view
    }()
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(body)
        clipsToBounds = true
        backgroundColor = statusColorOff
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        addGestureRecognizer(swipeGesture)
        snp.remakeConstraints { $0.width.equalTo(snp.height).multipliedBy(1.8) }
        configureViews()
    }
    
    private func configureViews() {
        addSubview(thumbView)
        thumbView.snp.remakeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.width.equalTo(thumbView.snp.height)
            thumbViewLeading = $0.leading.equalToSuperview().inset(4).constraint
            thumbViewTrailing = $0.trailing.equalToSuperview().inset(4).constraint
        }
        thumbViewLeading?.isActive = true
        thumbViewTrailing?.isActive = false
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    private func updateLayers() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
    public var body: UIView {
        FZStack {
            FImage(image: statusImageOff).contentMode(.scaleAspectFill).customConfiguration { [weak self] view in
                self?.statusImage = view
            }
            if let statusImageOn {
                FImage(image: statusImageOn).contentMode(.scaleAspectFill)
            }
        }.customConfiguration { view in
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.layer.borderWidth = 0.5
        }.shaped(.circle)
    }
    
    /// Updates the switch state and appearance with optional animation.
    /// - Parameters:
    ///   - on: Whether the switch should be turned on.
    ///   - animated: Whether to animate the change. Default is true.
    public func set(on: Bool, animated: Bool = true) {
        thumbViewLeading?.isActive = !isOn
        thumbViewTrailing?.isActive = isOn
        UIView.animate(withDuration: 0.2) { [self] in
            backgroundColor = isOn ? statusColorOn : statusColorOff
            statusImage?.image = isOn ? statusImageOn : statusImageOff
            layoutIfNeeded()
        }
        onSwitch?(isOn)
    }
    
    @objc private func onTap() { isOn.toggle() }
    
    @objc private func onSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left: isOn = false
        case .right: isOn = true
        default: break
        }
    }
    
    /// Sets a closure to be called when the switch state changes.
    /// - Parameter onSwitch: The callback with the updated state.
    /// - Returns: Self for fluent chaining.
    @discardableResult public func onSwitch(_ onSwitch: @escaping (Bool) -> Void) -> Self {
        self.onSwitch = onSwitch
        return self
    }
    
    /// Sets the color of the thumb view.
    /// - Parameter color: The color to apply.
    /// - Returns: Self for fluent chaining.
    @discardableResult public func thumb(_ color: UIColor) -> Self {
        self.thumUIColor = color
        return self
    }
    
    /// Sets the image of the thumb view.
    /// - Parameter image: The image to apply.
    /// - Returns: Self for fluent chaining.
    @discardableResult public func thumb(_ image: UIImage) -> Self {
        self.thumbImage = image
        return self
    }
    
    /// Sets background colors for on and off states.
    /// - Parameters:
    ///   - on: The color when the switch is on.
    ///   - off: The color when the switch is off.
    /// - Returns: Self for fluent chaining.
    @discardableResult public func background(on: UIColor = .white, off: UIColor = .systemGreen) -> Self {
        self.statusColorOff = off
        self.statusColorOn = on
        return self
    }
    
    /// Sets background images for on and off states.
    /// - Parameters:
    ///   - on: The image when the switch is on.
    ///   - off: The image when the switch is off.
    /// - Returns: Self for fluent chaining.
    @discardableResult public func background(on: UIImage, off: UIImage) -> Self {
        self.statusImageOff = off
        self.statusImageOn = on
        return self
    }
}
