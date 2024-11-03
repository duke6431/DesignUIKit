//
//  CommonTableView.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 23/07/2021.
//

import UIKit
import DesignCore

public class CommonTableView: UITableView, Loggable {
    public weak var actionDelegate: CommonTableViewDelegate?
#if os(iOS)
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
    lazy var customRefreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
        return view
    }()
#endif
    
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
    
    @objc public func startRefreshing() {
        actionDelegate?.refreshStarted?()
    }
    
#if os(iOS)
    public func endRefreshing() {
        customRefreshControl.endRefreshing()
    }
#endif
    
    public func reloadData(sections: [CommonTableSection]) {
        self.sections = sections
        search(with: keyword)
#if os(iOS)
        endRefreshing()
#endif
    }
    
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
    
    public func scrollToRow(at indexPath: IndexPath, at position: UITableView.ScrollPosition = .top) {
        if numberOfRows(inSection: indexPath.section) > indexPath.row {
            scrollToRow(at: indexPath, at: position, animated: true)
        }
    }
    
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
        logger.info("Deinitialized \(self)")
    }
}

extension CommonTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        searchedSections.count
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard searchedSections[section].header != nil else { return 0 }
        return UITableView.automaticDimension
    }
    
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedSections[section].items.count
    }
    
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
    
    @objc public func didSelectCell(at indexPath: IndexPath, with model: CommonCellModel) {
        actionDelegate?.didSelectCell?(at: indexPath, with: model)
    }
    
    @objc public func shouldLoadMore() {
        actionDelegate?.loadMore?()
    }
}

extension CommonTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard searchedSections[section].header != nil else { return CGFloat(Float.leastNonzeroMagnitude) }
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchedSections[indexPath.section].items[indexPath.row].selectable {
            didSelectCell(at: indexPath, with: searchedSections[indexPath.section].items[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
#if os(iOS)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        .init(actions: searchedSections[indexPath.section].items[indexPath.row].leadingActions)
    }
    
    // swiftlint:disable:next line_length
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        .init(actions: searchedSections[indexPath.section].items[indexPath.row].trailingActions)
    }
#endif
}

extension CommonTableView: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let count = searchedSections.last?.items.count else { return }
        if indexPaths.map({ ($0.section, $0.row) }).contains(where: { $0.0 == searchedSections.count - 1 && $0.1 == count - 1 }) {
            shouldLoadMore()
        }
    }
}
