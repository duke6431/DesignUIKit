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
    enum PresentStyle {
        case push
        case present
        case panModal(direction: PanModal.OriginDirection = .top)

        func present(target: UIViewController, source: UINavigationController?) {
            switch self {
            case .push:
                source?.pushViewController(target, animated: true)
            case .present:
                source?.present(target, animated: true)
            case .panModal(let direction):
                source?.present(target, dimmingView: .dimmingDefault, direction: direction)
            }
        }
    }

    case customKeyboard
    case commonTextField
    case customBottomSheet
    case commonStatusView
    case commonCollectionView

    var viewController: UIViewController? {
        switch self {
        case .customKeyboard:
            return KeyboardVC()
        case .commonTextField:
            return CommonTextFieldVC()
        case .commonStatusView:
            return CommonStatusViewVC()
        case .commonCollectionView:
            return CommonGalleryViewVC()
        default:
            return nil
        }
    }

    var presentationStyle: PresentStyle {
        .push
    }

    var action: ((UINavigationController) -> Void)? {
        switch self {
        case .customBottomSheet:
            return { navigationController in
                let childNavigationController = UINavigationController()
                let viewController = UIViewController()
                viewController.view.backgroundColor = .white
                childNavigationController.pushViewController(viewController, animated: true)
                navigationController.present(childNavigationController, dimmingView: .dimmingDefault, direction: .top)
            }
        default:
            return nil
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
        case .customBottomSheet:
            return "Trending bottom sheet"
        case .commonStatusView:
            return "Default status view with image, title and content"
        case .commonCollectionView:
            return "Common customizable collection view"
        @unknown default:
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
        unicodeScalars.dropFirst().reduce(String(prefix(1))) {
            CharacterSet.uppercaseLetters.contains($1) ? $0 + " " + String($1) : $0 + String($1)
        }
    }
}

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar(frame: .init(origin: .zero, size: .init(width: 0, height: 48)))
        tableView.tableHeaderView = view
        return view
    }()
    lazy var tableView: CommonTableView = {
        let view = CommonTableView(
            map: [ComponentCellModel.self],
            headerMap: [ComponentHeaderModel.self]
        )
        view.alwaysBounceVertical = true
        self.view.addSubview(view)
        view.actionDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        return view
    }()

    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        super.viewDidLoad()
        configureViews()
        bindActions()
        let components = CommonTableSection(
            header: ComponentHeaderModel(title: "This one is also the example of CommonTableView usage. Read the code in ViewController.swift for more!!"),
            items: Components.allCases.map({ feature in
                ComponentCellModel.init(name: feature.name, detail: feature.detail) { [weak self] in
                    if let viewController = feature.viewController {
                        viewController.title = feature.name
                        feature.presentationStyle.present(target: viewController, source: self?.navigationController)
                    } else if let action = feature.action {
                        action(self?.navigationController ?? UINavigationController())
                    }
                }
            })
        )
        tableView.reloadData(sections: [components])
    }

    func configureViews() {
        self.title = "Catalog"
        view.backgroundColor = .systemBackground
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
