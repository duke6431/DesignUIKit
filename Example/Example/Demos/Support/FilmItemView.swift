//
//  FilmItemView.swift
//  Example
//
//  Created by Duc IT. Nguyen Minh on 13/02/2024.
//

import UIKit
import DesignUIKit
import DesignCore

class FilmItemView: BaseView, FCellReusable {
    static var empty: Self {
        .init(title: "", imageUrl: "")
    }
    
    public class Content: NSObject, Chainable, FCellModeling {
        public var view: (UIView & FCellReusable).Type = FilmItemView.self
        public var title: String = ""
        public var imageUrl: String = ""
        public var note: String?
        public var duration: String = ""
        
        public init(title: String = "", imageUrl: String = "https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg",
                    note: String? = nil, duration: String = "0:00:00") {
            self.title = title
            self.imageUrl = imageUrl
            self.note = note
            self.duration = duration
        }
    }
    
    var content: Content = .init()
    
    var imageHeight: CGFloat? = 180
    var isSecure: Bool = true
    
    weak var imageView: FImage?
    weak var titleLabel: UILabel?
    weak var noteLabel: UILabel?
    weak var durationLabel: UILabel?
    
    required init(
        title: String, imageUrl: String,
        note: String? = nil, duration: String = "0:00:00",
        isSecure: Bool = true
    ) {
        super.init(frame: .zero)
        self.content = .init(
            title: title, imageUrl: imageUrl,
            note: note, duration: duration
        )
        self.isSecure = isSecure
        configureViews()
    }
    
    func configureViews() {
        subviews.forEach { $0.removeFromSuperview() }
        addSubview(body)
    }
    
    func bind(_ value: FCellModeling) {
        guard let value = value as? Content else { return }
        content = value
        titleLabel?.text = value.title.isEmpty ? "No title" : value.title
        imageView?.reload(url: .init(string: value.imageUrl))
        noteLabel?.text = value.note
        durationLabel?.text = value.duration
        
        noteLabel?.superview?.isHidden = value.note?.isEmpty ?? true
    }
    
    var body: UIView {
        FView {
            FStack(spacing: SpacingSystem.shared.spacing(.small)) {
                FView {
                    FImage(url: .init(string: content.imageUrl)) { [weak self] view, container in
                        self?.imageView = container
                        view.contentMode = .scaleAspectFill
                        return view
                    }
                    .frame(height: imageHeight)
                    FStack {
                        FSpacer()
                        FStack(axis: .horizontal) {
                            if let note = content.note, !note.isEmpty {
                                FLabel(
                                    text: note,
                                    font: FontSystem.shared.font(with: .body),
                                    color: .white
                                ) { [weak self] view, _ in
                                    self?.noteLabel = view
                                    return view
                                }
                                .background(.systemBlue.withAlphaComponent(0.6))
                                .shaped(.roundedRectangle(cornerRadius: 8))
                                .insets(SpacingSystem.shared.spacing(.extraSmall))
                                .padding([.left, .bottom], SpacingSystem.shared.spacing(.extraSmall))
                                
                            }
                            FSpacer()
                            FLabel(
                                text: content.duration,
                                font: FontSystem.shared.font(with: .body),
                                color: .white
                            ) { [weak self] view, _ in
                                self?.durationLabel = view
                                return view
                            }
                            .background(.lightGray.withAlphaComponent(0.3))
                            .shaped(.roundedRectangle(cornerRadius: 8))
                            .insets(SpacingSystem.shared.spacing(.extraSmall))
                            .padding([.right, .bottom], SpacingSystem.shared.spacing(.extraSmall))
                        }
                    }
                }
                FStack(axis: .horizontal) {
                    FLabel(
                        text: content.title.isEmpty ? "No title" : content.title,
                        font: FontSystem.shared.font(with: .headline),
                        color: .label,
                        lineLimit: 2
                    ) { [weak self] view, _ in
                        self?.titleLabel = view
                        return view
                    }
                    FSpacer()
                    FSwitch()
                }
                .padding([.left, .right], SpacingSystem.shared.spacing(.small))
                FSpacer()
            }
            .background(.white)
            .shaped(.roundedRectangle(cornerRadius: 16))
        }
        .shadow(.init(opacity: 0.3))
        .padding([.left, .right], SpacingSystem.shared.spacing(.regular))
        .padding([.top, .bottom], SpacingSystem.shared.spacing(.small))
    }
}
