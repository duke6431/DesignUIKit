//
//  FImage.swift
//
//
//  Created by Duc IT. Nguyen Minh on 11/02/2024.
//

import UIKit
import Combine
import Nuke
import SnapKit
import DesignCore

public class FImage: BaseImageView, FConfigurable, FComponent, FContentConstraintable {
    public var url: URL?
    
    public var customConfiguration: ((FImage) -> Void)?
    
    public init(
        image: UIImage? = nil, url: URL? = nil
    ) {
        self.url = url
        super.init(image: image)
    }

    public convenience init(
        systemImage: String
    ) {
        self.init(
            image: .init(systemName: systemImage)
        )
    }
    
    public convenience init(
        named: String, in bundle: Bundle = .main
    ) {
        self.init(
            image: .init(named: named, in: bundle, with: nil)
        )
    }
    
    public init(
        _ systemImagePublisher: AnyPublisher<String, Never>
    ) {
        super.init(frame: .zero)
        self.bind(to: systemImagePublisher) { imageView, name in imageView.image = .init(systemName: name) }
    }
    
    public init(
        _ imagePublisher: AnyPublisher<UIImage, Never>
    ) {
        super.init(frame: .zero)
        self.bind(to: imagePublisher) { imageView, image in imageView.image = image }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        if let url = url {
            image = nil
            ImagePipeline.shared.loadImage(with: url) { [weak self] result in
                if case .success(let response) = result, response.urlResponse?.url == self?.url {
                    self?.image = response.image
                }
            }
        }
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    public func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
}

public extension FImage {
    func reload(image: UIImage? = nil, url: URL?) {
        self.image = image
        self.url = url ?? self.url
        if let url = url {
            ImagePipeline.shared.loadImage(with: url) { [weak self] result in
                if case .success(let response) = result {
                    self?.image = response.image
                }
            }
        }
    }
}
