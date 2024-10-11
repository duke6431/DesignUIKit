//
//  File.swift
//  ComponentSystem
//
//  Created by Duc Nguyen on 11/10/24.
//

import UIKit
import DesignCore

public final class FForEach: FBodyComponent {
    public var customConfiguration: ((FForEach) -> Void)?
    public var contentViews: [FBodyComponent]
    
    public convenience init<T>(_ list: Array<T>, _ content: (T) -> FBodyComponent) {
        self.init(contentViews: list.map(content))
    }
    
    private init(contentViews: FBody) {
        self.contentViews = contentViews
        super.init(frame: .zero)
    }
    
    func content() -> [FBodyComponent] {
        contentViews.flatMap {
            (($0 as? FForEach)?.content() ?? [$0])
        }
    }
    
    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    public override func didMoveToSuperview() {
        fatalError("FForEach is not considered a view")
    }
    
    public override func layoutSubviews() {
        fatalError("FForEach is not considered a view")
    }
}
