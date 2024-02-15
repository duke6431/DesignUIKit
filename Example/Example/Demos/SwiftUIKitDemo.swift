//
//  ViewController.swift
//  Example
//
//  Created by Duc IT. Nguyen Minh on 04/02/2024.
//

import UIKit
import DesignUIKit
import SnapKit

class SwiftUIKitViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    var tableView = FList(prototypes: [FilmItemView.self])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableView.reloadData(sections: [
                CommonTableSection(items: [
                    FModel(model: FilmItemView.Content(title: "Test", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Test_card.png")),
                    FModel(model: FilmItemView.Content()),
                    FModel(model: FilmItemView.Content()),
                    FModel(model: FilmItemView.Content()),
                    FModel(model: FilmItemView.Content()),
                    FModel(model: FilmItemView.Content()),
                    FModel(model: FilmItemView.Content()),
                    FModel(model: FilmItemView.Content()),
                    FModel(model: FilmItemView.Content()),
                    FModel(model: FilmItemView.Content()),
                ])
            ])
//        }
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
//        let view = FilmItemView(
//            title: "Test", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Test_card.png",
////            title: "Test", imageUrl: "",
//            note: "Uncensored leak", duration: "1:00:00",
//            isSecure: false
//        )
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
//        view.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview().inset(24)
//            $0.center.equalToSuperview()
//        }
    }
}

