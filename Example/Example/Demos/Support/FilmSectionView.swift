//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import UIKit
import DesignCore
import DesignUIKit

struct FilmSection {
    var title: String
    var items: [FilmItemView.Content]
}

public class FilmSectionView: FContainer, FCellReusable {
    public static var empty: Self { .init() }
    public var padding: UIEdgeInsets = .zero
    
    weak var grid: FGrid?
    
    var content: Content = .init()
    
    public class Content: FCellModeling {
        public var view: (UIView & DesignUIKit.FCellReusable).Type = FilmSectionView.self
        
        var sections: [CommonCollection.Section] = []
        
        init(_ sections: [FilmSection] = []) {
            self.sections = sections.map {
                .init(
                    header: FGridHeaderModel(model: FilmSectionHeader.Content(title: $0.title)),
                    cells: $0.items.map {
                        FGridModel(model: $0)
                    }
                )
                .with(dimension: .init(
                    itemWHRatio: 1.4, groupWidthRatio: 1.0, groupSpacing: 0,
                    sectionInset: .zero,
                    headerSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)),
                    pagingBehaviour: .groupPaging
                ))
                .with(layout: CommonCollection.Section.slidingLayout(section:))
            }
        }
    }
    
    required init(sections: [FilmSection] = []) {
        content = .init(sections)
        super.init(frame: .zero)
    }
    
    public func bind(_ value: FCellModeling) {
        guard let value = value as? Content else { return }
        content = value
        grid?.reloadData(sections: value.sections)
    }
    
    public override var body: UIView {
        FGrid(
            prototypes: [FilmItemView.self],
            headerPrototypes: [FilmSectionHeader.self]
        ) { [weak self] view, grid in
            self?.grid = grid
            return view
        }
    }
}

public class FilmSectionHeader: FContainer, FCellReusable {
    public static var empty: Self { .init() }

    public func bind(_ value: FCellModeling) {
        guard let value = value as? Content else { return }
        content = value
        titleLabel?.text = value.title
    }
    
    public class Content: FCellModeling {
        public var view: (UIView & DesignUIKit.FCellReusable).Type = FilmSectionHeader.self
        var title: String?
        
        init(title: String? = nil) {
            self.title = title
        }
    }
    
    weak var titleLabel: UILabel?
    var content: Content = .init()
    
    required init(title: String? = nil) {
        content = .init(title: title)
        super.init(frame: .zero)
    }
    
    public override var body: UIView {
        FStack(axis: .horizontal) {
            FLabel(
                text: content.title ?? "",
                font: FontSystem.shared.font(
                    with: .title2.updated(\.weight, with: .semibold)
                )
            ) { [weak self] view, label in
                self?.titleLabel = view
                return view
            }
        }
        .padding([.left, .right], SpacingSystem.shared.spacing(.regular))
    }
}
