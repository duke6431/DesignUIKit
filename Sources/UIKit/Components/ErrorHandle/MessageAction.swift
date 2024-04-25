//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 4/23/24.
//

import Foundation
import DesignCore

public enum MActionStyle {
    case `default`
    case recover
    case destructive
    case cancel
}

public class MAction: FView {
    var axis: BAxis = .horizontal
    var icon: BImage?
    var title: String?
    var attributedTitle: NSAttributedString?
    var customView: FBodyComponent?
    
    var style: MActionStyle = .default
    
    var action: (() -> Void)?
    
    public override var body: FBodyComponent {
        FButton {
            if let customView {
                customView
            } else {
                if icon != nil, title != nil || attributedTitle != nil {
                    FStack(axis: axis, arrangedContents: content)
                } else {
                    FZStack(contentViews: content)
                }
            }
        } action: { [weak self] in
            self?.action?()
        }
    }
    
    @FViewBuilder var content: FBody {
        if let icon {
            FImage(image: icon)
        }
        if let attributedTitle {
            FLabel(attributedTitle)
        } else if let title {
            FLabel(title)
        }
    }
}

public extension MAction {
    static var ok: MAction {
        .init().customized {
            $0.title = "OK"
            $0.style = .cancel
        }
    }
}
