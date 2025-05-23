//
//  CommonTableView.swift
//  DesignUIKit
//
//  Created by Duke Nguyen on 2021/07/23.
//
//  CommonTableView is a reusable and customizable UITableView subclass designed to handle complex table view
//  configurations with support for multiple cell and header types, refresh control, searching, and loading more data.
//  It provides a delegate protocol for handling user interactions and refresh events.
//
//  Features:
//  - Supports multiple cell and header model types.
//  - Provides a built-in refresh control (iOS only).
//  - Supports searching and filtering of table data.
//  - Supports swipe actions on cells (iOS only).
//  - Handles prefetching for loading more data.
//  - Provides caching for cell and header types for improved performance.
//

import UIKit
import DesignCore

/// A customizable UITableView subclass that supports multiple cell and header types, refreshing, searching, and loading more data.
public class CommonTableView: UITableView, Loggable {
    /// Delegate to handle actions such as cell selection, refresh, and loading more data.
    public weak var actionDelegate: CommonTableViewDelegate?
    
#if os(iOS)
    /// A Boolean value that determines whether the table view supports pull-to-refresh functionality.
    public var refreshable: Bool = false {
        didSet {
            if refreshable { addSubview(customRefreshControl) } else { customRefreshControl.removeFromSuperview() }
        }
    }
#endif
    
    let cellMapper: [CommonCellModel.Type]
    let headerMapper: [CommonHeaderModel.Type]
    var cellCache: CommonCellModel.Type?
    var headerCache: CommonHeaderModel.Type?
    var sections: [CommonTableSection] = []
    var searchedSections: [CommonTableSection] = []
    var keyword = ""
    
#if os(iOS)
    /// The refresh control used for pull-to-refresh functionality.
    lazy var customRefreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
        return view
    }()
#endif
    
    /// Initializes a new CommonTableView with specified cell and header mappers and style.
    ///
    /// - Parameters:
    ///   - map: An array of `CommonCellModel.Type` representing the cell types to register.
    ///   - headerMap: An optional array of `CommonHeaderModel.Type` representing header types to register.
    ///   - style: The UITableView style. Defaults to `.plain`.
    public init(
        map: [CommonCellModel.Type],
        headerMap: [CommonHeaderModel.Type] = [],
        style: UITableView.Style = .plain
    ) {
        self.cellMapper = map
        self.headerMapper = headerMap
        super.init(frame: .zero, style: style)
        configureViews()
    }
    
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    /// Configures the table view's appearance and registers cell and header types.
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        register(UITableViewCell.self)
        dataSource = self
        delegate = self
        prefetchDataSource = self
        backgroundColor = .clear
        tableFooterView = UIView()
        keyboardDismissMode = .onDrag
        if #available(iOS 15.0, tvOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
        rowHeight = UITableView.automaticDimension
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        estimatedRowHeight = 44.0
        cellMapper.forEach { register($0.cellKind) }
        headerMapper.forEach { register($0.headerKind) }
    }
    
    /// Starts the refresh control animation and notifies the delegate that refresh has started.
    @objc public func startRefreshing() {
        actionDelegate?.refreshStarted?()
    }
    
#if os(iOS)
    /// Ends the refresh control animation.
    public func endRefreshing() {
        customRefreshControl.endRefreshing()
    }
#endif
    
    /// Reloads the table view data with the specified sections and applies the current search keyword.
    ///
    /// - Parameter sections: An array of `CommonTableSection` representing the sections to display.
    public func reloadData(sections: [CommonTableSection]) {
        self.sections = sections
        search(with: keyword)
#if os(iOS)
        endRefreshing()
#endif
    }
    
    /// Filters the table view data based on the provided keyword and reloads the table.
    ///
    /// - Parameter keyword: The search keyword used to filter items.
    public func search(with keyword: String) {
        self.keyword = keyword
        guard !keyword.isEmpty else {
            searchedSections = sections
            reloadData()
            return
        }
        searchedSections = sections.map {
            CommonTableSection(
                header: $0.header,
                items: $0.items.filter {
                    $0.isHighlighted?(with: keyword) ?? true
                }
            )
        }.filter { $0.items.count > 0 }
        reloadData()
    }
    
    /// Scrolls the table view to the specified row at a given position.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the row to scroll to.
    ///   - position: The scroll position. Defaults to `.top`.
    public func scrollToRow(at indexPath: IndexPath, at position: UITableView.ScrollPosition = .top) {
        if numberOfRows(inSection: indexPath.section) > indexPath.row {
            scrollToRow(at: indexPath, at: position, animated: true)
        }
    }
    
    /// Deletes an item from the table view with the specified identifier.
    ///
    /// - Parameter identifier: The unique identifier of the item to delete.
    public func deleteItem(with identifier: String) {
        var selectedItem = IndexPath(row: 0, section: 0)
        for (index, section) in sections.enumerated() {
            var stop = false
            selectedItem.section = index
            for (index, item) in section.items.enumerated() where identifier == item.identifier {
                selectedItem.row = index
                stop = true
            }
            if stop { break }
        }
        sections[selectedItem.section].items.remove(at: selectedItem.row)
        for (index, section) in searchedSections.enumerated() {
            var stop = false
            selectedItem.section = index
            for (index, item) in section.items.enumerated() where identifier == item.identifier {
                selectedItem.row = index
                stop = true
            }
            if stop { break }
        }
        searchedSections[selectedItem.section].items.remove(at: selectedItem.row)
        for cell in visibleCells as? [CommonTableView.TableCell] ?? [] where cell.identifier == identifier {
            selectedItem = cell.indexPath ?? selectedItem
        }
        deleteRows(at: [selectedItem], with: .fade)
        if searchedSections[selectedItem.section].items.count == 0 {
            searchedSections.remove(at: selectedItem.section)
            deleteSections(IndexSet(integer: selectedItem.section), with: .fade)
        }
    }
    
    deinit {
        logger.trace("Deinitialized \(self)")
    }
}

extension CommonTableView: UITableViewDataSource {
    /// Returns the number of sections in the table view.
    ///
    /// - Parameter tableView: The UITableView requesting this information.
    /// - Returns: The number of sections.
    public func numberOfSections(in tableView: UITableView) -> Int {
        searchedSections.count
    }
    
    /// Returns the estimated height for the header in a given section.
    ///
    /// - Parameters:
    ///   - tableView: The UITableView requesting this information.
    ///   - section: The index of the section.
    /// - Returns: The estimated height of the header.
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard searchedSections[section].header != nil else { return 0 }
        return UITableView.automaticDimension
    }
    
    /// Returns the view for the header in a given section.
    ///
    /// - Parameters:
    ///   - tableView: The UITableView requesting this view.
    ///   - section: The index of the section.
    /// - Returns: A UIView to use as the header, or nil if no header.
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerData = searchedSections[section].header else {
            return nil
        }
        if let cachedMap = headerCache {
            let header = tableView.dequeue(cachedMap.headerKind)
            header.section = section
            header.bind(headerData)
            headerData.customConfiguration?(header)
            return header
        }
        guard let map = headerMapper.first(where: { headerData.isKind(of: $0) }) else {
            return nil
        }
        headerCache = map
        let header = tableView.dequeue(map.headerKind)
        header.section = section
        header.bind(headerData)
        headerData.customConfiguration?(header)
        return header
    }
    
    /// Returns the number of rows in a given section.
    ///
    /// - Parameters:
    ///   - tableView: The UITableView requesting this information.
    ///   - section: The index of the section.
    /// - Returns: The number of rows in the section.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedSections[section].items.count
    }
    
    /// Returns the cell for a given index path.
    ///
    /// - Parameters:
    ///   - tableView: The UITableView requesting the cell.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A configured UITableViewCell.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = searchedSections[indexPath.section].items[indexPath.row]
        if let cachedMap = cellCache, item.isKind(of: cachedMap) {
            let cell = tableView.dequeue(cachedMap.cellKind)
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            cell.bind(item, highlight: keyword)
            return cell
        }
        guard let map = cellMapper.first(where: { item.isKind(of: $0) }) else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
        cellCache = map
        let cell = tableView.dequeue(map.cellKind)
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        cell.bind(item, highlight: keyword)
        return cell
    }
    
    /// Called when a cell is selected.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the selected cell.
    ///   - model: The model associated with the selected cell.
    @objc public func didSelectCell(at indexPath: IndexPath, with model: CommonCellModel) {
        actionDelegate?.didSelectCell?(at: indexPath, with: model)
    }
    
    /// Called when the table view should load more data (e.g., for pagination).
    @objc public func shouldLoadMore() {
        actionDelegate?.loadMore?()
    }
}

extension CommonTableView: UITableViewDelegate {
    /// Returns the height for the header in a given section.
    ///
    /// - Parameters:
    ///   - tableView: The UITableView requesting this information.
    ///   - section: The index of the section.
    /// - Returns: The height of the header.
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard searchedSections[section].header != nil else { return CGFloat(Float.leastNonzeroMagnitude) }
        return UITableView.automaticDimension
    }
    
    /// Returns the height for a row at a given index path.
    ///
    /// - Parameters:
    ///   - tableView: The UITableView requesting this information.
    ///   - indexPath: The index path of the row.
    /// - Returns: The height of the row.
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    /// Called when a row is selected.
    ///
    /// - Parameters:
    ///   - tableView: The UITableView notifying the selection.
    ///   - indexPath: The index path of the selected row.
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchedSections[indexPath.section].items[indexPath.row].selectable {
            didSelectCell(at: indexPath, with: searchedSections[indexPath.section].items[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
#if os(iOS)
    /// Returns the leading swipe actions configuration for a row at a given index path.
    ///
    /// - Parameters:
    ///   - tableView: The UITableView requesting the configuration.
    ///   - indexPath: The index path of the row.
    /// - Returns: A UISwipeActionsConfiguration containing the leading actions.
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        .init(actions: searchedSections[indexPath.section].items[indexPath.row].leadingActions)
    }
    
    /// Returns the trailing swipe actions configuration for a row at a given index path.
    ///
    /// - Parameters:
    ///   - tableView: The UITableView requesting the configuration.
    ///   - indexPath: The index path of the row.
    /// - Returns: A UISwipeActionsConfiguration containing the trailing actions.
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        .init(actions: searchedSections[indexPath.section].items[indexPath.row].trailingActions)
    }
#endif
}

extension CommonTableView: UITableViewDataSourcePrefetching {
    /// Called when the table view is about to prefetch data for cells at the specified index paths.
    ///
    /// - Parameters:
    ///   - tableView: The UITableView requesting the prefetch.
    ///   - indexPaths: An array of index paths representing the rows to prefetch.
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let count = searchedSections.last?.items.count else { return }
        if indexPaths.map({ ($0.section, $0.row) }).contains(where: { $0.0 == searchedSections.count - 1 && $0.1 == count - 1 }) {
            shouldLoadMore()
        }
    }
}
