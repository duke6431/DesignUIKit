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
    weak var list: FList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        list?.separatorStyle = .none
        // Do any additional setup after loading the view.
        list?.reloadData(sections: [
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
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
        self.view.addSubview(
            FList(prototypes: [FilmItemView.self]) { [weak self] view, list in
                self?.list = list
                return view
            }
        )
    }
}

