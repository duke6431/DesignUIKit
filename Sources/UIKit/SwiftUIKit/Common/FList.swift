//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import Combine
import DesignExts
import SnapKit

public class FList: CommonTableView, FConfigurable, FComponent {
    public var customConfiguration: ((FList) -> Void)?

    public var onSelect: ((FListModel) -> Void)?
    public weak var content: CommonTableView?
    
    public var cancellables = Set<AnyCancellable>()

    public init(prototypes: [(FCellReusable & UIView).Type], style: UITableView.Style = .plain) {
        super.init(map: [], headerMap: [], style: style)
        prototypes.forEach { register(FListCell.self, forCellReuseIdentifier: String(describing: $0)) }
        loadConfiguration()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        customConfiguration?(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = searchedSections[indexPath.section].items[indexPath.row] as? FListModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: item.model.view)) as? FListCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        cell.bind(item, highlight: keyword)
        return cell
    }

    open func loadConfiguration() {
        configuration = .init()
    }
}

public extension FList {
    override func didSelectCell(at indexPath: IndexPath, with model: CommonCellModel) {
        super.didSelectCell(at: indexPath, with: model)
        guard let model = model as? FListModel else { return }
        onSelect?(model)
    }
    
    @discardableResult func onSelect(_ action: @escaping (FListModel) -> Void) -> Self {
        onSelect = action
        return self
    }
}

public protocol FCellModeling {
    var view: (FCellReusable & UIView).Type { get set }
}

public protocol FCellReusable: AnyObject {
    static var empty: Self { get }
    func bind(_ value: FCellModeling)
}

public class FListModel: NSObject, CommonCellModel {
    public var identifier: String = UUID().uuidString
    public static var cellKind: CommonTableView.Cell.Type = FListCell.self
    public var selectable: Bool = true
    public var customConfiguration: ((CommonTableView.Cell) -> Void)?
    public var leadingActions: [UIContextualAction] = []
    public var trailingActions: [UIContextualAction] = []
    public var padding: UIEdgeInsets = .zero
    public var model: FCellModeling
    public var realData: Any?
    
    public init(
        model: FCellModeling,
        realData: Any? = nil
    ) {
        self.model = model
        self.realData = realData
    }
}

public class FListCell: CommonTableView.Cell {
    weak var content: FCellReusable?
    
    public override func bind(_ model: CommonCellModel, highlight text: String) {
        guard let model = model as? FListModel else { return }
        if content == nil { install(view: model.model.view.empty) }
        content?.bind(model.model)
    }

    open func install<T: FCellReusable & UIView>(view: T) {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(view)
        view.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        content = view
    }
}
