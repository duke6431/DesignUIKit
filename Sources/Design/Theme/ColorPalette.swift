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

public protocol ColorName {
    var name: String { get }
}

public protocol ImageName {
    var name: String { get }
}

public class Palette: NSObject {
    fileprivate var colorDict: [String: () -> UIColor] = [:]
    fileprivate var imageDict: [String: () -> UIImage?] = [:]
    
    subscript(_ name: ColorName) -> UIColor {
        colorDict[name.name]?() ?? .systemBlue
    }
    
    subscript(_ name: ImageName) -> UIImage? {
        imageDict[name.name]?()
    }
}

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
            if property.starts(with: "img") {
                palette.imageDict[property] = {
                    UIImage(dynamicImageWithLight: UIImage(named: light[property] ?? "", in: Theme.bundle, compatibleWith: nil), dark: UIImage(named: dark?[property] ?? "", in: Theme.bundle, compatibleWith: nil))
                }
            } else {
                palette.colorDict[property] = {
                    UIColor(dynamicProvider: { traitCollection -> UIColor in
                        if traitCollection.userInterfaceStyle == .light {
                            return UIColor(hexString: light[property] ?? "")
                        } else {
                            return UIColor(hexString: dark?[property] ?? "")
                        }
                    })
                }
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
