//
//  File.swift
//  
//
//  Created by Duke Nguyen on 18/01/2024.
//

import SwiftUI
import Foundation

public enum DeviceSystem: Int, Codable, @unchecked Sendable {
    
    case unspecified = -1
    
    case phone = 0
    
    case pad = 1
    
    case tv = 2
    
    case carPlay = 3
    
    case mac = 5
    
    case vision = 6 // Vision UI
    
    public static var current: DeviceSystem {
#if os(macOS)
        return .mac
#elseif os(iOS) || os(tvOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return .phone
        case .pad:
            return .pad
        case .tv:
            return .tv
        case .carPlay:
            return .carPlay
        case .mac:
            return .mac
        default:
            if #available(iOS 17.0, tvOS 17.0, *) {
                if UIDevice.current.userInterfaceIdiom == .vision {
                    return .vision
                }
            }
            return .unspecified
        }
#endif
    }
}
