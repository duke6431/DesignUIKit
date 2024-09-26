//
//  File.swift
//  
//
//  Created by Duc Minh Nguyen on 3/27/24.
//

import UIKit

public protocol ImageRepresenting {
    var image: BImage? { get }
}

public enum ImageRepresenter: ImageRepresenting {
    case system(name: String)
    case asset(name: String, bundle: Bundle = .main)
    
    public var image: BImage? {
        switch self {
        case .system(let name):
            return .init(systemName: name)
        case .asset(let name, let bundle):
            return .init(named: name, in: bundle, with: .none)
        }
    }
}
