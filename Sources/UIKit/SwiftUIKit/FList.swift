//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import DesignExts

public class FList: CommonTableView {
    public init(prototypes: [(FViewReusable & UIView).Type], style: UITableView.Style = .plain) {
        super.init(map: [], headerMap: [], style: style)
        prototypes.forEach { register(FRow.self, forCellReuseIdentifier: String(describing: $0)) }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = searchedSections[indexPath.section].items[indexPath.row] as? FModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: item.model.view)) as? FRow else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        cell.bind(item, highlight: keyword)
        return cell
    }
}

public protocol FModeling {
    var view: (FViewReusable & UIView).Type { get set }
}

public protocol FViewReusable: AnyObject {
    static var empty: Self { get }
    var padding: UIEdgeInsets { get set }
    func bind(_ value: FModeling)
}

public class FModel: NSObject, CommonCellModel {
    public var identifier: String = UUID().uuidString
    public static var cellKind: CommonTableView.Cell.Type = FRow.self
    public var selectable: Bool = true
    public var customConfiguration: ((CommonTableView.Cell) -> Void)?
    public var leadingActions: [UIContextualAction] = []
    public var trailingActions: [UIContextualAction] = []
    public var padding: UIEdgeInsets = .zero
    public var model: FModeling
    public var realData: Any?
    
    public init(
        model: FModeling,
        realData: Any? = nil
    ) {
        self.model = model
        self.realData = realData
    }
}

public class FRow: CommonTableView.Cell {
    weak var content: FViewReusable?
    
    public override func bind(_ model: CommonCellModel, highlight text: String) {
        guard let model = model as? FModel else { return }
        if content == nil { install(view: model.model.view.empty) }
        content?.bind(model.model)
    }

    open func install<T: FViewReusable & UIView>(view: T) {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.top.equalToSuperview().inset(view.padding.top)
            $0.leading.equalToSuperview().inset(view.padding.left)
            $0.trailing.equalToSuperview().inset(view.padding.right)
            $0.bottom.equalToSuperview().inset(view.padding.bottom)
        }
        content = view
    }
}
