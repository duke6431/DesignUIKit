//
//  File.swift
//  
//
//  Created by Duc IT. Nguyen Minh on 17/02/2024.
//

import UIKit

public protocol MessageHandlable {
    // TODO: 4 alert style: pop up, toast, drop down, bottom sheet
    // low: toast: just for show
    // medium: bottom sheet: show error and recoveries options
    // high dropdown: just show error and maybe a dangerous recoveries options
    // unknown error: pop up: center in screen, nothing can be done here
    // The style should be configurable
}
