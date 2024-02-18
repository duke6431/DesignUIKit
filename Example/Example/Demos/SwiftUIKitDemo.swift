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
    weak var list: FilmSectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
//        list?.separatorStyle = .none
//        // Do any additional setup after loading the view.
        list?.bind(FilmSectionView.Content([
            .init(title: "Recommend", items: [
                FilmItemView.Content(title: "Test", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Test_card.png"),
                FilmItemView.Content(),
                FilmItemView.Content(),
                FilmItemView.Content(),
                FilmItemView.Content(),
                FilmItemView.Content(),
                FilmItemView.Content(),
                FilmItemView.Content(),
                FilmItemView.Content(),
                FilmItemView.Content(),
            ])
        ]))
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(
            FilmSectionView().customized({
                list = $0
            })
//            FList(prototypes: [FilmSectionView.self]) { [weak self] view, list in
//                self?.list = list
//                return view
//            }
        )
        list?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

