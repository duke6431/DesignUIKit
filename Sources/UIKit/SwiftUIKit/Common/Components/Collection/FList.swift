//
//  FList.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2024/02/15.
//
//  A modular table view component for rendering cell and header content using reusable FBody-based views.
//  Supports dynamic cell models, selection, infinite scrolling, and layout customization.
//

import UIKit
import DesignCore
import DesignExts
import SnapKit

/// A reusable table view component that displays sections and rows using FBody-based cell and header views.
/// Provides support for cell registration, layout configuration, selection handling, and pagination.
public final class FList: CommonTableView, FConfigurable, FComponent, FAssignable {
    /// A closure to define the layout constraints of the list relative to its superview.
    public var layoutConfiguration: ((ConstraintMaker, UIView) -> Void)?
    /// A closure to apply additional configuration to the list after setup.
    public var customConfiguration: ((FList) -> Void)?
    
    /// A callback triggered when a list cell is selected.
    public var onSelect: ((FListModel) -> Void)?
    /// A callback triggered when pagination (load more) is invoked.
    public var onMore: (() -> Void)?
    /// A reference to the underlying table view (self).
    public weak var content: CommonTableView?
    
    /// Initializes the FList with optional header and cell prototypes.
    /// - Parameters:
    ///   - headerPrototypes: Header types to register.
    ///   - prototypes: Cell types to register.
    ///   - style: The table view style (plain or grouped).
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
    
    /// Loads the default configuration object for styling and lifecycle delegation.
    public func loadConfiguration() {
        configuration = .init()
    }
    
    @available(iOS, deprecated: 1.0, message: "Use reloadData(sections:) instead")
    public func reload() { }
}

public extension FList {
    /// Handles row selection and forwards the selected model via the `onSelect` callback.
    override func didSelectCell(at indexPath: IndexPath, with model: CommonCellModel) {
        super.didSelectCell(at: indexPath, with: model)
        guard let model = model as? FListModel else { return }
        onSelect?(model)
    }
    
    /// Triggers the `onMore` callback when the list reaches the end for pagination.
    override func shouldLoadMore() {
        super.shouldLoadMore()
        onMore?()
    }
    
    /// Sets a callback for row selection.
    /// - Parameter action: A closure accepting the selected `FListModel`.
    /// - Returns: Self for chaining.
    @discardableResult func onSelect(_ action: @escaping (FListModel) -> Void) -> Self {
        onSelect = action
        return self
    }
    
    /// Sets a callback for the pagination trigger.
    /// - Parameter action: A closure called when more data should load.
    /// - Returns: Self for chaining.
    @discardableResult func onMore(_ action: @escaping () -> Void) -> Self {
        onMore = action
        return self
    }
}

/// A model representing a reusable cell with layout configuration.
public protocol FCellModeling {
    var view: (FBodyComponent & FCellReusable).Type { get set }
    func layoutConfiguration(container: UIView, view: UIView?)
}

public extension FCellModeling {
    func layoutConfiguration(container: UIView, view: UIView?) { }
}

/// A model representing a reusable header with layout configuration.
public protocol FHeaderModeling {
    var view: (FBodyComponent & FHeaderReusable).Type { get set }
    func layoutConfiguration(container: UIView, view: UIView?)
}

public extension FHeaderModeling {
    func layoutConfiguration(container: UIView, view: UIView?) { }
}

/// A reusable cell capable of binding to an `FCellModeling` object.
public protocol FCellReusable: AnyObject {
    static var empty: Self { get }
    func bind(_ value: FCellModeling)
}

/// A reusable header capable of binding to an `FHeaderModeling` object.
public protocol FHeaderReusable: AnyObject {
    static var empty: Self { get }
    func bind(_ value: FHeaderModeling)
}

/// A protocol for applying full custom configuration to cells or headers.
@objc public protocol FFullCustomConfiguration: AnyObject {
    @objc optional func customized(header: FListHeader)
    @objc optional func customized(cell: FListCell)
}

/// A protocol for applying partial custom configuration to cells or headers.
@objc public protocol FPartialCustomConfiguration: AnyObject {
    @objc optional func customized(header: FListHeader)
    @objc optional func customized(cell: FListCell)
}

/// A wrapper model for reusable header content used with `FList`.
public class FHeaderModel: NSObject, CommonHeaderModel {
    public var identifier: String = UUID().uuidString
    public static var headerKind: CommonTableView.Header.Type = FListHeader.self
    public var customConfiguration: ((CommonTableView.Header) -> Void)?
    public var model: FHeaderModeling

    public init(model: FHeaderModeling) {
        self.model = model
    }
}

/// A wrapper model for reusable cell content used with `FList`.
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

/// A concrete table view cell that hosts an `FBodyComponent` cell view.
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

/// A concrete table view header that hosts an `FBodyComponent` header view.
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
