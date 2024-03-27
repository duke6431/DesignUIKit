//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 16/02/2024.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
import Combine
import SnapKit
import DesignCore

public class FSwitch: BView, FComponent {
    public var customConfiguration: ((FSwitch) -> Void)?
    public var cancellables = Set<AnyCancellable>()
    
    public enum Style {
        case sliding
        case checkbox
    }
    
    public var isOn: Bool = false {
        didSet {
            set(on: isOn)
        }
    }
    
    public var thumbImage: BImage?
    public var thumbColor: BColor = .white
    public var statusColorOff: BColor = .white
    public var statusColorOn: BColor = .systemGreen
    public var statusImageOff: BImage?
    public var statusImageOn: BImage?
    
    private var onSwitch: ((Bool) -> Void)?
    
    private weak var statusImage: BImageView?
    private var thumbViewTrailing: Constraint?
    private lazy var thumbView: BView = {
        let view = FZStack {
            if let thumbImage {
                FImage(image: thumbImage).contentMode(.scaleAspectFill)
            }
        }
            .background(thumbColor)
            .shaped(.circle)
            .shadow(.init(opacity: 0.4, radius: 3))
            .customized {
                $0.configuration?.shouldConstraintWithParent = false
            }
        view.snp.remakeConstraints {
            $0.width.equalTo(view.snp.height)
        }
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
        snp.remakeConstraints {
            $0.width.equalTo(snp.height).multipliedBy(1.8)
        }
        configureViews()
    }
    
    public func configureViews() {
        addSubview(thumbView)
        thumbView.snp.remakeConstraints {
            $0.verticalEdges.equalToSuperview().inset(2)
            $0.leading.equalToSuperview().inset(2).priority(.medium)
            thumbViewTrailing = $0.trailing.equalToSuperview().inset(2).constraint
        }
        thumbViewTrailing?.isActive = false
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    func updateLayers() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
    public var body: BView {
        FZStack {
            FImage(image: statusImageOff).contentMode(.scaleAspectFill).customConfiguration { [weak self] view in
                self?.statusImage = view
            }
            if let statusImageOn {
                FImage(image: statusImageOn).contentMode(.scaleAspectFill)
            }
        }.customConfiguration { view in
            view.layer.borderColor = BColor.lightGray.cgColor
            view.layer.borderWidth = 0.5
        }.shaped(.circle)
    }
    
    public func set(on: Bool, animated: Bool = true) {
        thumbViewTrailing?.isActive = isOn
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = self.isOn ? self.statusColorOn : self.statusColorOff
            self.statusImage?.image = self.isOn ? self.statusImageOn : self.statusImageOff
            self.layoutIfNeeded()
        }
    }
    
    @objc public func onTap() {
        isOn.toggle()
    }
    
    @objc public func onSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            isOn = false
        case .right:
            isOn = true
        default:
            break
        }
    }

    @discardableResult func onSwitch(_ onSwitch: @escaping (Bool) -> Void) -> Self {
        self.onSwitch = onSwitch
        return self
    }
    
    @discardableResult func thumb(_ color: BColor) -> Self {
        self.thumbColor = color
        return self
    }
    
    @discardableResult func thumb(_ image: BImage) -> Self {
        self.thumbImage = image
        return self
    }
    
    @discardableResult func background(on: BColor = .white, off: BColor = .systemGreen) -> Self {
        self.statusColorOff = off
        self.statusColorOn = on
        return self
    }
    
    @discardableResult func background(on: BImage, off: BImage) -> Self {
        self.statusImageOff = off
        self.statusImageOn = on
        return self
    }
}
