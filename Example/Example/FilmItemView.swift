//
//  FilmItemView.swift
//  Example
//
//  Created by Duc IT. Nguyen Minh on 13/02/2024.
//

import UIKit
import DesignUIKit
import DesignCore

class FilmItemView: BaseView, FViewReusable {
    static var empty: Self {
        .init(title: "", imageUrl: "")
    }
    
    public class Content: NSObject, Chainable, FModeling {
        public var view: (UIView & DesignUIKit.FViewReusable).Type = FilmItemView.self
        public var title: String = ""
        public var imageUrl: String = ""
        public var note: String?
        public var duration: String = ""
        
        public init(title: String = "", imageUrl: String = "",
             note: String? = nil, duration: String = "0:00:00") {
            self.title = title
            self.imageUrl = imageUrl
            self.note = note
            self.duration = duration
        }
    }
    
    var content: Content = .init()
    
    public var padding: UIEdgeInsets = .init(top: 12, left: 24, bottom: 12, right: 24)
    var imageHeight: CGFloat? = 220
    var isSecure: Bool = true
    
    weak var imageView: UIImageView?
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
        backgroundColor = .white
        subviews.forEach { $0.removeFromSuperview() }
        let content = body
        addSubview(content)
    }
    
    func bind(_ value: FModeling) {
        guard let value = value as? Content else { return }
        titleLabel?.text = value.title
        noteLabel?.text = value.note
        durationLabel?.text = value.duration
        
        noteLabel?.superview?.isHidden = value.note?.isEmpty ?? true
    }
    
    var body: UIView {
        FStack(spacing: SpacingSystem.shared.spacing(.small)) {
            FView {
                FImage(url: .init(string: content.imageUrl)) { [weak self] view, _ in
                    self?.imageView = view
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
            .shaped(.roundedRectangle(cornerRadius: SpacingSystem.shared.spacing(.extraSmall) * 3))
            FLabel(
                text: content.title.isEmpty ? "No title" : content.title,
                font: FontSystem.shared.font(with: .headline),
                color: .label,
                lineLimit: 2
            ) { [weak self] view, _ in
                self?.titleLabel = view
                return view
            }
            .padding([.left, .right], SpacingSystem.shared.spacing(.regular))
            FSpacer()
        }
        .background(.white)
        .shaped(.roundedRectangle(cornerRadius: 24))
        .shadow(.init(opacity: 0.3))
    }
}
