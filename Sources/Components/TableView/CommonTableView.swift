//
//  CommonTableView.swift
//  Components
//
//  Created by Duc IT. Nguyen Minh on 23/07/2021.
//

import UIKit
import DesignCore
#if canImport(DesignToolbox)
import DesignToolbox
#endif

// TODO: Add refresh protocols

public class CommonTableView: UIView {
    public weak var delegate: CommonTableViewDelegate?

    public var refreshable: Bool = false {
        didSet {
            if refreshable { tableView.addSubview(refreshControl) } else { refreshControl.removeFromSuperview() }
        }
    }

    public var bounces: Bool {
        get { tableView.bounces }
        set { tableView.bounces = newValue }
    }
    public var alwaysBounceVertical: Bool {
        get { tableView.alwaysBounceVertical }
        set { tableView.alwaysBounceVertical = newValue }
    }
    public var alwaysBounceHorizontal: Bool {
        get { tableView.alwaysBounceHorizontal }
        set { tableView.alwaysBounceHorizontal = newValue }
    }

    private let style: UITableView.Style
    private let cellMapper: [CommonTableConfigPair]
    private let headerMapper: [CommonTableHeaderConfigPair]
    private var mapCache: CommonTableConfigPair?
    private var headerMapCache: CommonTableHeaderConfigPair?
    private var sections: [CommonTableSection] = []
    private var searchedSections: [CommonTableSection] = []
    private var keyword = ""

    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
        return view
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: frame, style: style)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public init(map: [CommonTableConfigPair], headerMap: [CommonTableHeaderConfigPair] = [], style: UITableView.Style = .plain) {
        self.cellMapper = map
        self.headerMapper = headerMap
        self.style = style
        super.init(frame: .zero)
        configureViews()
    }

    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    func configureViews() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.estimatedRowHeight = 44.0
        cellMapper.forEach { tableView.register($0.cell) }
        headerMapper.forEach { tableView.register($0.header) }
    }

    @objc func startRefreshing() {
        delegate?.refreshStarted?()
    }

    public func endRefreshing() {
        refreshControl.endRefreshing()
    }

    public func reloadData(sections: [CommonTableSection]) {
        self.sections = sections
        search(with: keyword)
        endRefreshing()
    }

    public func search(with keyword: String) {
        self.keyword = keyword
        guard !keyword.isEmpty else {
            searchedSections = sections
            tableView.reloadData()
            return
        }
        searchedSections = sections.map({
            CommonTableSection(header: $0.header,
                               items: $0.items.filter({ $0.isHighlighted(with: keyword) }))
        }).filter({ $0.items.count > 0 })
        tableView.reloadData()
    }

    public func scrollToRow(at indexPath: IndexPath, at position: UITableView.ScrollPosition = .top) {
        if tableView.numberOfRows(inSection: indexPath.section) > indexPath.row {
            tableView.scrollToRow(at: indexPath, at: position, animated: true)
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
        for cell in tableView.visibleCells as? [CommonCell] ?? [] where cell.identifier == identifier {
            selectedItem = cell.indexPath ?? selectedItem
        }
        tableView.deleteRows(at: [selectedItem], with: .fade)
        if searchedSections[selectedItem.section].items.count == 0 {
            searchedSections.remove(at: selectedItem.section)
            tableView.deleteSections(IndexSet(integer: selectedItem.section), with: .fade)
        }
    }
}

extension CommonTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        searchedSections.count
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerData = searchedSections[section].header else {
            return nil
        }
        if let cachedMap = headerMapCache {
            let header = tableView.dequeue(cachedMap.header)
            header.section = section
            header.bind(headerData)
            headerData.customConfigurartion?(header)
            return header
        }
        guard let map = headerMapper.first(where: { headerData.isKind(of: $0.model) }) else {
            return nil
        }
        headerMapCache = map
        let header = tableView.dequeue(map.header)
        header.section = section
        header.bind(headerData)
        headerData.customConfigurartion?(header)
        return header
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedSections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = searchedSections[indexPath.section].items[indexPath.row]
        if let cachedMap = mapCache, item.isKind(of: cachedMap.model) {
            let cell = tableView.dequeue(cachedMap.cell)
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            cell.bind(item, highlight: keyword)
            return cell
        }
        guard let map = cellMapper.first(where: { item.isKind(of: $0.model) }) else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
        mapCache = map
        let cell = tableView.dequeue(map.cell)
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        cell.bind(item, highlight: keyword)
        return cell
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
            delegate?.didSelectCell?(at: indexPath, with: searchedSections[indexPath.section].items[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        .init(actions: searchedSections[indexPath.section].items[indexPath.row].leadingActions)
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        .init(actions: searchedSections[indexPath.section].items[indexPath.row].trailingActions)
    }
}
