//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 16/02/2024.
//

import UIKit
import SnapKit
import DesignCore

public class FSwitch: UIView {
    public enum Style {
        case sliding
        case checkbox
    }
    
    public var isOn: Bool = false {
        didSet {
            set(on: isOn)
        }
    }
    
    public var thumbImage: UIImage?
    public var thumbColor: UIColor = .white
    public var statusColorOff: UIColor = .white
    public var statusColorOn: UIColor = .systemGreen
    public var statusImageOff: UIImage?
    public var statusImageOn: UIImage?
    
    private var onSwitch: ((Bool) -> Void)?
    
    private weak var statusImage: UIImageView?
    private var thumbViewTrailing: Constraint?
    private lazy var thumbView: UIView = {
        let view = FZStack {
            if let thumbImage {
                FImage(image: thumbImage).contentMode(.scaleAspectFill)
            }
        }
            .background(thumbColor)
            .shaped(.circle)
            .shadow(.init(opacity: 0.4, radius: 3))
            .with(\.shouldConstraintWithParent, setTo: false)
        view.snp.makeConstraints {
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
        snp.makeConstraints {
            $0.width.equalTo(snp.height).multipliedBy(1.8)
        }
        configureViews()
    }
    
    public func configureViews() {
        addSubview(thumbView)
        thumbView.snp.makeConstraints {
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
    
    public var body: UIView {
        FZStack {
            FImage(image: statusImageOff).contentMode(.scaleAspectFill).customConfiguration { [weak self] view, _ in
                self?.statusImage = view
                return view
            }
            if let statusImageOn {
                FImage(image: statusImageOn).contentMode(.scaleAspectFill)
            }
        }.customConfiguration { view, container in
            container.layer.borderColor = UIColor.lightGray.cgColor
            container.layer.borderWidth = 0.5
            return view
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

    func onSwitch(_ onSwitch: @escaping (Bool) -> Void) -> Self {
        self.onSwitch = onSwitch
        return self
    }
    
    func thumb(_ color: UIColor) -> Self {
        self.thumbColor = color
        return self
    }
    
    func thumb(_ image: UIImage) -> Self {
        self.thumbImage = image
        return self
    }
    
    func background(on: UIColor = .white, off: UIColor = .systemGreen) -> Self {
        self.statusColorOff = off
        self.statusColorOn = on
        return self
    }
    
    func background(on: UIImage, off: UIImage) -> Self {
        self.statusImageOff = off
        self.statusImageOn = on
        return self
    }
}
