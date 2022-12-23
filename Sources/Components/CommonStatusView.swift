//
//  CommonStatusView.swift
//  DesignToolbox
//
//  Created by Duc IT. Nguyen Minh on 12/07/2022.
//

import UIKit
import DesignToolbox

public class CommonStatusView: UIView {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return view
    }()
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public var image: UIImage? { didSet { imageView.image = image } }
    public var title: String? { didSet { titleLabel.text = title } }
    public var subtitle: String? { didSet { subtitleLabel.text = subtitle } }
    public var titleColor: UIColor = .label { didSet { titleLabel.textColor = titleColor } }
    public var titleFont: UIFont = FontSystem.shared.defaultFont.font(with: UIFont.DefaultStyle.title2) { didSet { titleLabel.font = titleFont } }
    public var subtitleColor: UIColor = .secondaryLabel { didSet { subtitleLabel.textColor = subtitleColor } }
    public var subtitleFont: UIFont = FontSystem.shared.defaultFont.font(with: UIFont.DefaultStyle.body) { didSet { subtitleLabel.font = subtitleFont } }

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
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3.5/5)
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        titleLabel.textColor = titleColor
        titleLabel.font = titleFont
        subtitleLabel.textColor = subtitleColor
        subtitleLabel.font = subtitleFont
    }
}
