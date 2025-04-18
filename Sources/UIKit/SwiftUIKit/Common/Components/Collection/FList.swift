//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 15/02/2024.
//

import UIKit
import DesignCore
import DesignExts
import SnapKit

public class FList: CommonTableView, FConfigurable, FComponent, FAssignable {
    public var layoutConfiguration: ((ConstraintMaker, UIView) -> Void)?
    public var customConfiguration: ((FList) -> Void)?

    public var onSelect: ((FListModel) -> Void)?
    public var onMore: (() -> Void)?
    public weak var content: CommonTableView?

    public init(
        headerPrototypes: [(FHeaderReusable & UIView).Type]? = nil,
        prototypes: [(FCellReusable & UIView).Type],
        style: UITableView.Style = .plain
    ) {
        super.init(map: [], headerMap: [], style: style)
        headerPrototypes?.forEach { register(FListHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: $0)) }
        prototypes.forEach { register(FListCell.self, forCellReuseIdentifier: String(describing: $0)) }
        loadConfiguration()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configuration?.didMoveToSuperview(superview, with: self)
        if let layoutConfiguration, let superview {
            snp.makeConstraints { make in
                layoutConfiguration(make, superview)
            }
        }
        customConfiguration?(self)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configuration?.updateLayers(for: self)
    }

    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = searchedSections[section].header as? FHeaderModel,
              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: item.model.view)) as? FListHeader else { return nil }
        header.section = section
        header.bind(item)
        return header
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

    public func loadConfiguration() {
        configuration = .init()
    }
    
    @available(iOS, deprecated: 1.0, message: "Use reloadData(sections:) instead")
    public func reload() { }
}

public extension FList {
    override func didSelectCell(at indexPath: IndexPath, with model: CommonCellModel) {
        super.didSelectCell(at: indexPath, with: model)
        guard let model = model as? FListModel else { return }
        onSelect?(model)
    }

    override func shouldLoadMore() {
        super.shouldLoadMore()
        onMore?()
    }

    @discardableResult func onSelect(_ action: @escaping (FListModel) -> Void) -> Self {
        onSelect = action
        return self
    }

    @discardableResult func onMore(_ action: @escaping () -> Void) -> Self {
        onMore = action
        return self
    }
}

public protocol FCellModeling {
    var view: (FBodyComponent & FCellReusable).Type { get set }
    func layoutConfiguration(container: UIView, view: UIView?)
}

public extension FCellModeling {
    func layoutConfiguration(container: UIView, view: UIView?) { }
}

public protocol FHeaderModeling {
    var view: (FBodyComponent & FHeaderReusable).Type { get set }
    func layoutConfiguration(container: UIView, view: UIView?)
}

public extension FHeaderModeling {
    func layoutConfiguration(container: UIView, view: UIView?) { }
}

public protocol FCellReusable: AnyObject {
    static var empty: Self { get }
    func bind(_ value: FCellModeling)
}

public protocol FHeaderReusable: AnyObject {
    static var empty: Self { get }
    func bind(_ value: FHeaderModeling)
}

@objc public protocol FFullCustomConfiguration: AnyObject {
    @objc optional func customized(header: FListHeader)
    @objc optional func customized(cell: FListCell)
}

@objc public protocol FPartialCustomConfiguration: AnyObject {
    @objc optional func customized(header: FListHeader)
    @objc optional func customized(cell: FListCell)
}

public class FHeaderModel: NSObject, CommonHeaderModel {
    public var identifier: String = UUID().uuidString
    public static var headerKind: CommonTableView.Header.Type = FListHeader.self
    public var customConfiguration: ((CommonTableView.Header) -> Void)?
    public var model: FHeaderModeling

    public init(model: FHeaderModeling) {
        self.model = model
    }
}

public class FListModel: NSObject, CommonCellModel, Loggable {
    public var identifier: String = UUID().uuidString
    public static var cellKind: CommonTableView.TableCell.Type = FListCell.self
    public var selectable: Bool = true
    public var customConfiguration: ((CommonTableView.TableCell) -> Void)?
    #if os(iOS)
    public var leadingActions: [UIContextualAction] = []
    public var trailingActions: [UIContextualAction] = []
    #endif
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

    deinit {
        logger.trace("Deinitializing \(model)")
        logger.trace("Deinitialized \(self)")
    }
}

public class FListCell: CommonTableView.TableCell, Loggable {
    weak var content: (FBodyComponent & FCellReusable)?

    public override func bind(_ model: CommonCellModel, highlight text: String) {
        guard let model = model as? FListModel else { return }
        if content == nil {
            install(view: model.model.view.empty)
            model.model.layoutConfiguration(container: contentView, view: content)
        }
        content?.bind(model.model)
    }

    open func install<T: FBodyComponent & FCellReusable>(view: T) {
        if let customizeContent = view as? FFullCustomConfiguration {
            customizeContent.customized?(cell: self)
        } else {
            contentView.backgroundColor = .clear
            backgroundColor = .clear
            view.attachToParent(false)
            contentView.addSubview(view)
            view.snp.makeConstraints {
                $0.directionalEdges.equalToSuperview()
            }
            content = view
            if let content = view as? FPartialCustomConfiguration {
                content.customized?(cell: self)
            }
        }
    }

    deinit {
        if let content { logger.trace("Deinitializing \(content)") }
        logger.trace("Deinitialized \(self)")
    }
}

public class FListHeader: CommonTableView.Header {
    weak var content: (FBodyComponent & FHeaderReusable)?

    public override func bind(_ model: CommonHeaderModel) {
        guard let model = model as? FHeaderModel else { return }
        if content == nil {
            install(view: model.model.view.empty)
            model.model.layoutConfiguration(container: contentView, view: content)
        }
        content?.bind(model.model)
    }

    open func install<T: FBodyComponent & FHeaderReusable>(view: T) {
        if let customizeContent = view as? FFullCustomConfiguration {
            customizeContent.customized?(header: self)
        } else {
            contentView.backgroundColor = .clear
            backgroundColor = .clear
            view.attachToParent(false)
            contentView.addSubview(view)
            view.snp.makeConstraints {
                $0.directionalEdges.equalToSuperview()
            }
            content = view
            if let content = view as? FPartialCustomConfiguration {
                content.customized?(header: self)
            }
        }
    }
}
