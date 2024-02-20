//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import DesignExts
import SnapKit

public class FList: CommonTableView, FComponent {
    public var shape: FShape?
    public var shadow: CALayer.ShadowConfiguration?
    public var contentBackgroundColor: UIColor = .clear
    
    public var width: CGFloat?
    public var height: CGFloat?
    public var containerPadding: UIEdgeInsets?
    public var contentInsets: UIEdgeInsets?
    public var shouldConstraintWithParent: Bool = true
    public var customConfiguration: ((CommonTableView, FList) -> CommonTableView)?

    public weak var content: CommonTableView?

    public init(prototypes: [(FCellReusable & UIView).Type], style: UITableView.Style = .plain, customConfiguration: ((CommonTableView, FList) -> CommonTableView)? = nil) {
        super.init(map: [], headerMap: [], style: style)
        prototypes.forEach { register(FListCell.self, forCellReuseIdentifier: String(describing: $0)) }
        self.customConfiguration = customConfiguration
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if shouldConstraintWithParent {
            snp.makeConstraints {
                $0.top.equalToSuperview().inset(containerPadding?.top ?? 0)
                $0.leading.equalToSuperview().inset(containerPadding?.left ?? 0)
                $0.trailing.equalToSuperview().inset(containerPadding?.right ?? 0)
                $0.bottom.equalToSuperview().inset(containerPadding?.bottom ?? 0)
                if let width { $0.width.equalTo(width) }
                if let height { $0.height.equalTo(height) }
            }
        }
        _ = customConfiguration?(self, self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    func updateLayers() {
        if let shape {
            clipsToBounds = true
            UIView.animate(withDuration: 0.2) {
                switch shape {
                case .circle:
                    self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
                case .roundedRectangle(let cornerRadius, let corners):
                    self.layer.maskedCorners = corners.caMask
                    self.layer.cornerRadius = min(cornerRadius, min(self.bounds.width, self.bounds.height) / 2)
                }
            }
        }
        if let shadow {
            UIView.animate(withDuration: 0.2) {
                self.layer.add(
                    shadow: shadow.updated(
                        \.path, with: UIBezierPath(rect: self.bounds).cgPath
                    )
                )
            }
        }
    }
    
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        self.width = width
        self.height = height
        return self
    }
    
    @available(iOS, deprecated, message: "This function of FList and FGrid should not be called")
    public func rendered() -> CommonTableView {
        fatalError("Never call this function of FList!")
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
        view.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        content = view
    }
}
