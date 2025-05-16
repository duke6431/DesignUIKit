//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 16/02/2024.
//

import UIKit
import SnapKit
import DesignCore

public final class FSwitch: BaseView, FComponent {
    public var customConfiguration: ((FSwitch) -> Void)?
    
    public var isOn: Bool = false { didSet { set(on: isOn) } }
    
    public var thumbImage: UIImage?
    public var thumUIColor: UIColor = .white
    public var statusColorOff: UIColor = .white
    public var statusColorOn: UIColor = .systemGreen
    public var statusImageOff: UIImage?
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

    @discardableResult public func onSwitch(_ onSwitch: @escaping (Bool) -> Void) -> Self {
        self.onSwitch = onSwitch
        return self
    }
    
    @discardableResult public func thumb(_ color: UIColor) -> Self {
        self.thumUIColor = color
        return self
    }
    
    @discardableResult public func thumb(_ image: UIImage) -> Self {
        self.thumbImage = image
        return self
    }
    
    @discardableResult public func background(on: UIColor = .white, off: UIColor = .systemGreen) -> Self {
        self.statusColorOff = off
        self.statusColorOn = on
        return self
    }
    
    @discardableResult public func background(on: UIImage, off: UIImage) -> Self {
        self.statusImageOff = off
        self.statusImageOn = on
        return self
    }
}
