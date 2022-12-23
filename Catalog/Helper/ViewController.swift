//
//  ViewController.swift
//  Catalog
//
//  Created by Duc IT. Nguyen Minh on 18/05/2022.
//

import UIKit
import DesignComponents
import RxCocoa
import RxSwift

enum Components: String, CaseIterable {
    case commonTableView
    case customKeyboard
    case commonTextField

    var viewController: UIViewController {
        switch self {
        case .commonTableView:
            return UIViewController()
        case .customKeyboard:
            return KeyboardVC()
        case .commonTextField:
            return CommonTextFieldVC()
        }
    }
    var name: String {
        return rawValue.camelCaseToWords().capitalized
    }

    var detail: String? {
        switch self {
        case .customKeyboard:
            return "Create any keyboard with ease"
        case .commonTextField:
            return "Text field that every app need"
        default:
            return "Something descriptive..."
        }

    }
}

enum Core: String, CaseIterable {
    case textFieldProtocol

    var viewController: UIViewController {
        switch self {
        case .textFieldProtocol:
            return UIViewController()
        }
    }
    var name: String {
        return rawValue.camelCaseToWords().capitalized
    }
    var detail: String? {
        return "Something descriptive..."
    }
}

extension String {
    func camelCaseToWords() -> String {
        return unicodeScalars.dropFirst().reduce(String(prefix(1))) {
            return CharacterSet.uppercaseLetters.contains($1)
            ? $0 + " " + String($1)
            : $0 + String($1)
        }
    }
}
class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        return view
    }()
    lazy var tableView: CommonTableView = {
        let view = CommonTableView(map: [(ComponentCellModel.self, ComponentCell.self)])
        view.alwaysBounceVertical = true
        self.view.addSubview(view)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindActions()
        let components = CommonTableSection(items: Components.allCases.map({ feature in
            ComponentCellModel.init(name: feature.name, detail: feature.detail) { [weak self] in
                let viewController = feature.viewController
                viewController.title = feature.name
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }))
        tableView.reloadData(sections: [components])
    }

    func configureViews() {
        self.title = "Catalog"
        view.backgroundColor = .systemBackground
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
    }

    func bindActions() {
        searchBar.rx.text.changed.compactMap { $0 }.bind(onNext: tableView.search).disposed(by: disposeBag)
    }
}

extension ViewController: CommonTableViewDelegate {
    func didSelectCell(at indexPath: IndexPath, with data: CommonCellModel) {
        guard let data = data as? ComponentCellModel else {
            return
        }
        data.action?()
    }
}
