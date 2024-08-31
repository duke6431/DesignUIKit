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

public class FilmSectionView: FView, FCellReusable {
    public static var empty: Self { .init() }
    public var padding: UIEdgeInsets = .zero
    
    weak var grid: FGrid?
    
    var content: Content = .init()
    
    public class Content: FCellModeling {
        public var view: (FBodyComponent & FCellReusable).Type = FilmSectionView.self
        
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
                    itemWHRatio: 1.15, autoHeight: true, groupWidthRatio: 0.93, groupSpacing: 0,
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
    
    public override var body: FBodyComponent {
        FGrid(
            prototypes: [FilmItemView.self],
            headerPrototypes: [FilmSectionHeader.self]
        ).customConfiguration { [weak self] grid in
            self?.grid = grid
        }
    }
}

public class FilmSectionHeader: FView, FCellReusable {
    public static var empty: Self { .init() }
    
    public func bind(_ value: FCellModeling) {
        guard let value = value as? Content else { return }
        content = value
        titleLabel?.text = value.title?.capitalized
    }
    
    public class Content: FCellModeling {
        public var view: (FBodyComponent & DesignUIKit.FCellReusable).Type = FilmSectionHeader.self
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

    public override var body: FBodyComponent {
        FStack(axis: .horizontal) {
            FLabel(content.title?.capitalized ?? "")
                .font(FontSystem.shared.font(with: .title2.updated(\.weight, with: .semibold)))
                .customConfiguration { [weak self] view in
                    self?.titleLabel = view
                }
        }
        .padding([.leading, .trailing], SpacingSystem.shared.spacing(.large))
    }
}
