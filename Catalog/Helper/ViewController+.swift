//
//  ViewController+.swift
//  Catalog
//
//  Created by Duc IT. Nguyen Minh on 23/05/2022.
//

import UIKit
//import Automation
#if canImport(Logger)
import Logger
#endif
import DesignComponents

extension ViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        let steps: [Executable] = [
//            Step(action: .searchAndExec(nil, { (_: UISearchBar) in return true }, {
//                $0.text = Components.customKeyboard.name
//                $0.searchTextField.sendActions(for: .editingChanged)
//            })),
//            Step(action: .searchAndExec(nil, { (_: UITableViewCell) in return true }, { (cell: UITableViewCell) in
//                cell.tap()
//            })),
//            Step(action: .searchAndExec(nil, { (_: CommonTextField) in return true }, {
//                $0.becomeFirstResponder()
//            }))
//        ]
//        StepGroup(name: "Main", steps: steps) { status in
//#if canImport(Logger)
//            Logger.default.info("Automation status: \(status ? "👌" : "💥")")
//            Logger.default.info("🚀🚀🚀 Main complete 🚀🚀🚀")
//#endif
//        }.execute()
    }
}
