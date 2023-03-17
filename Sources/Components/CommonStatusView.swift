//
//  CommonStatusView.swift
//  DesignToolbox
//
//  Created by Duc IT. Nguyen Minh on 12/07/2022.
//

import UIKit
import DesignCore
import DesignToolbox

public class CommonStatusView: UIView {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()
    // MARK: - Content
    public var image: UIImage? { didSet { imageView.image = image } }
    public var title: String? { didSet { titleLabel.text = title } }
    public var subtitle: String? { didSet { subtitleLabel.text = subtitle } }
    public var titleColor: UIColor = .label { didSet { titleLabel.textColor = titleColor } }
    public var titleFont: UIFont = FontSystem.font(with: .title2) { didSet { titleLabel.font = titleFont } }
    public var subtitleColor: UIColor = .secondaryLabel { didSet { subtitleLabel.textColor = subtitleColor } }
    public var subtitleFont: UIFont = FontSystem.font(with: .body) { didSet { subtitleLabel.font = subtitleFont } }

    // MARK: - Distribution, Size and Anchors
    public var alignment: Alignment = .center { didSet { change(from: oldValue, to: alignment) } }
    // swiftlint:disable:next line_length
    public var imageRatio: CGFloat = 1.0 { didSet { imageRatioConstraint = imageRatioConstraint.setMultiplier(multiplier: imageRatio) } }
    public var imageToTitleSpacing: CGFloat = 28 { didSet { imageTitleConstraint.constant = imageToTitleSpacing } }
    // swiftlint:disable:next line_length
    public var titleToSubtitleSpacing: CGFloat = 12 { didSet { titleSubtitleConstraint.constant = titleToSubtitleSpacing } }
    public var imageWidthAnchor: NSLayoutDimension { imageView.widthAnchor }

    public lazy var imageWidthSizeConstraint: NSLayoutConstraint = {
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3.0/5)
    }()
    private lazy var imageRatioConstraint: NSLayoutConstraint = {
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: imageRatio)
    }()
    private lazy var imageTitleConstraint: NSLayoutConstraint = {
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: imageToTitleSpacing)
    }()
    private lazy var titleSubtitleConstraint: NSLayoutConstraint = {
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleToSubtitleSpacing)
    }()
    private var alignmentConstraints: [Alignment: [NSLayoutConstraint]] = [:]

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureViews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    func configureViews() {
        [imageView, titleLabel, subtitleLabel].forEach(addSubview)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageRatioConstraint,
            imageWidthSizeConstraint,
            imageTitleConstraint,
            titleSubtitleConstraint,
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        titleLabel.textColor = titleColor
        titleLabel.font = titleFont
        subtitleLabel.textColor = subtitleColor
        subtitleLabel.font = subtitleFont
        change(to: alignment)
    }

    func change(from old: Alignment? = nil, to new: Alignment) {
        switch new {
        case .left:
            titleLabel.textAlignment = .left
            subtitleLabel.textAlignment = .left
        case .center:
            titleLabel.textAlignment = .center
            subtitleLabel.textAlignment = .center
        case .right:
            titleLabel.textAlignment = .right
            subtitleLabel.textAlignment = .right
        }
        guard let constraints = alignmentConstraints[new] else {
            NSLayoutConstraint.activate(load(new))
            return
        }
        NSLayoutConstraint.activate(constraints)
        guard let old = old, let constraints = alignmentConstraints[old] else { return }
        NSLayoutConstraint.deactivate(constraints)
    }

    func load(_ alignment: Alignment) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        switch alignment {
        case .left:
            constraints.append(imageView.leadingAnchor.constraint(equalTo: leadingAnchor))
            constraints.append(titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor))
            constraints.append(titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor))
            constraints.append(subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor))
            constraints.append(subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor))
        case .center:
            constraints.append(imageView.centerXAnchor.constraint(equalTo: centerXAnchor))
            constraints.append(titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
            constraints.append(titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor))
            constraints.append(subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
            constraints.append(subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor))
        case .right:
            constraints.append(imageView.trailingAnchor.constraint(equalTo: trailingAnchor))
            constraints.append(titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor))
            constraints.append(titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor))
            constraints.append(subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor))
            constraints.append(subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor))
        }
        alignmentConstraints[alignment] = constraints
        return constraints
    }
}
