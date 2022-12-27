//
//  ColorPalette.swift
//  Life
//
//  Created by Duc Minh Nguyen on 11/5/21.
//

import UIKit
import DesignCore
#if canImport(LoggerCenter)
import LoggerCenter
#endif

public class Palette: NSObject { }

public extension Palette {
    var name: String {
        return String(describing: Self.self).lowercased().replacingOccurrences(of: "palette", with: "")
    }
}

public class ColorPalette: NSObject {
    public private(set) var palette: Palette
    
    init(container: Palette, light: Palette, dark: Palette? = nil) {
        self.palette = container
        super.init()
#if canImport(LoggerCenter)
        LogCenter.default.verbose("Initializing color palette type \(palette.name)")
#endif
        guard let colorCodesLight = readFrom(plist: light.name) else {
#if canImport(LoggerCenter)
            LogCenter.default.warning("Couldn't initialize for color palette adaptive type \(light.name)")
#endif
            return
        }
        guard let dark = dark, let colorCodesDark = readFrom(plist: dark.name) else {
#if canImport(LoggerCenter)
            LogCenter.default.warning("Couldn't initialize for color palette adaptive type \(dark.name)")
#endif
            load(into: palette, with: colorCodesLight)
            return
        }
        load(into: palette, with: colorCodesLight, and: colorCodesDark)
    }
    
    func load(into palette: Palette, with light: [String: String], and dark: [String: String]? = nil) {
        for property in light.keys {
            guard palette.responds(to: .init(property)) else {
#if canImport(LoggerCenter)
                LogCenter.default.warning("Property '\(property)' not found on '\(palette.name)'")
#else
                print("Property '\(property)' not found on '\(palette.name)'")
#endif
                return
            }
            if property.starts(with: "img") {
                palette.setValue(UIImage(dynamicImageWithLight: UIImage(named: light[property] ?? "", in: .main, compatibleWith: nil), dark: UIImage(named: dark?[property] ?? "", in: .main, compatibleWith: nil)), forKeyPath: property)
            } else {
                palette.setValue(UIColor(dynamicProvider: { traitCollection -> UIColor in
                    if traitCollection.userInterfaceStyle == .light {
                        return UIColor(hexString: light[property] ?? "")
                    } else {
                        return UIColor(hexString: dark?[property] ?? "")
                    }
                }), forKeyPath: property)
            }
        }
    }
    
    public func currentPalette<T: Palette>() -> T? {
        return palette as? T
    }
    
    func readFrom(plist name: String) -> [String: String]? {
        if let path = Theme.bundle.path(forResource: name, ofType: "plist"), let colorCodes = NSDictionary(contentsOfFile: path) as? [String: String] {
            return colorCodes
        }
        return nil
    }
}

@available(iOS 13.0, *)
extension UITraitCollection {
    /// Creates the provided image with traits from the receiver.
    func makeImage(_ makeImage: UIImage) -> UIImage {
        var image: UIImage!
        performAsCurrent {
            image = makeImage
        }
        return image
    }
}
