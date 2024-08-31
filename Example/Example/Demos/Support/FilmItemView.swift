//
//  FilmItemView.swift
//  Example
//
//  Created by Duc IT. Nguyen Minh on 13/02/2024.
//

import UIKit
import DesignUIKit
import DesignCore

class FilmItemView: FView, FCellReusable {
    static var empty: Self {
        .init(title: "", imageUrl: "")
    }
    
    public class Content: NSObject, Chainable, FCellModeling {
        public var view: (FBodyComponent & FCellReusable).Type = FilmItemView.self
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
    
    override var body: FBodyComponent {
        FZStack {
            FVStack(spacing: 0) {
                FZStack {
                    FImage(url: .init(string: content.imageUrl))
                        .ratio(2)
                    FVStack {
                        FSpacer()
                        FHStack {
                            if let note = content.note, !note.isEmpty {
                                FZStack {
                                    FLabel(note)
                                        .font(FontSystem.shared.font(with: .body))
                                        .foreground(.white)
                                        .shaped(.roundedRectangle(cornerRadius: 8))
                                        .background(.systemBlue.withAlphaComponent(0.6))
                                        .padding([.leading, .bottom], SpacingSystem.shared.spacing(.extraSmall))
                                        .customConfiguration { [weak self] view in
                                            self?.noteLabel = view
                                        }
                                }
                            }
                            FSpacer()
                            FZStack {
                                FLabel(content.duration)
                                    .font(FontSystem.shared.font(with: .body))
                                    .foreground(.white)
                                    .customConfiguration { [weak self] view in
                                        self?.durationLabel = view
                                    }
                                    .background(.lightGray.withAlphaComponent(0.3))
                                    .shaped(.roundedRectangle(cornerRadius: 8))
                                    .insets(SpacingSystem.shared.spacing(.extraSmall))
                                    .padding([.trailing, .bottom], SpacingSystem.shared.spacing(.extraSmall))
                            }
                        }
                    }
                }
                FVStack(spacing: 0) {
                    FLabel(content.title.isEmpty ? "No title" : content.title)
                        .font(FontSystem.shared.font(with: .headline))
                        .foreground(.black)
                        .insets(SpacingSystem.shared.spacing(.regular))
                        .lineLimit(2)
                        .customConfiguration { [weak self] view in
                            self?.titleLabel = view
                        }
                    FSpacer()
                }
                .padding([.top, .bottom], SpacingSystem.shared.spacing(.small))
                .padding([.leading, .trailing], SpacingSystem.shared.spacing(.extraSmall) * 3)
            }
            .background(.white)
            .shaped(.roundedRectangle(cornerRadius: 16))
        }
        .shadow(.init(opacity: 0.6, color: .black))
        .padding([.leading, .trailing], SpacingSystem.shared.spacing(.regular))
        .padding([.top, .bottom], SpacingSystem.shared.spacing(.regular))
    }
}
