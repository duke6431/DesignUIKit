//
//  File.swift
//  ComponentSystem
//
//  Created by Duke Nguyen on 26/9/24.
//

import Foundation
import DesignRxUIKit
import RxSwift
import RxCocoa
import DesignUIKit

func to(theme: Int) {
    let navigator = ThemeNav()

}

protocol ThemeNavigaing: BaseNavigating {
    func apply(theme: Int)
}

final class ThemeNav: BaseNavigator, ThemeNavigaing {
    func apply(theme: Int) {

    }
}

final class ThemeVM: ViewModeling {
    struct Input {
        var load: Driver<Void>
    }
    struct Output {
        var binder: Binder<String>
    }

    var theme: Int

    init(theme: Int) {
        self.theme = theme
    }

    func connect(_ input: Input, with output: Output) {

    }
}

final class ThemeVC: FScene<ThemeVM> {
    weak var titleLabel: FLabel?

    override var body: any FBodyComponent {
        FLabel("").customized { titleLabel = $0 }
    }

    override var input: ThemeVM.Input {
        .init(load: .just(()))
    }

    override var output: ThemeVM.Output {
        .init(binder: titleBinder)
    }

    var titleBinder: Binder<String> {
        .init(self) { container, text in
            container.titleLabel?.text = text
        }
    }
}
