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

public protocol Palette: NSObject {
    var name: String { get }
    var background: UIColor? { get }
    var primary: UIColor? { get }
    var imgEmpty: UIImage? { get }
    var accent: UIColor? { get }
}

public extension Palette {
    var name: String {
        return String(describing: Self.self).lowercased().replacingOccurrences(of: "palette", with: "")
    }
}

public class LightPalette: NSObject, Palette {
    @objc public var background: UIColor?
    @objc public var primary: UIColor?
    @objc public var accent: UIColor?
    @objc public var imgEmpty: UIImage?
}
public class DarkPalette: NSObject, Palette {
    public var background: UIColor?
    @objc public var primary: UIColor?
    @objc public var accent: UIColor?
    @objc public var imgEmpty: UIImage?
}
public class AdaptivePalette: NSObject, Palette {
    @objc public var background: UIColor?
    @objc public var primary: UIColor?
    @objc public var accent: UIColor?
    @objc public var imgEmpty: UIImage?
}

public class ColorPalette: NSObject {
    public private(set) var palette: Palette

    static let light = ColorPalette(palette: LightPalette())
    static let dark = ColorPalette(palette: DarkPalette())
    @available(iOS 13.0, *)
    static let adaptive = ColorPalette(palette: AdaptivePalette())

    init(palette: Palette) {
        self.palette = palette
        super.init()
        if palette.isKind(of: AdaptivePalette.self) {
            if #available(iOS 13.0, *) {
                guard let colorCodesLight = self.readFrom(plist: LightPalette().name) else {
#if canImport(LoggerCenter)
                    LogCenter.default.warning("Couldn't initialize for color palette adaptive type \(LightPalette().name)")
#endif
                    return
                }
                guard let colorCodesDark = self.readFrom(plist: DarkPalette().name) else {
#if canImport(LoggerCenter)
                    LogCenter.default.warning("Couldn't initialize for color palette adaptive type \(DarkPalette().name)")
#endif
                    return
                }
#if canImport(LoggerCenter)
                LogCenter.default.verbose("Initializing color palette type \(palette.name)")
#endif
                for property in colorCodesLight.keys {
                    if property.starts(with: "img") {
                        palette.setValue(UIImage(dynamicImageWithLight: UIImage(named: colorCodesLight[property] ?? "", in: .main, compatibleWith: nil), dark: UIImage(named: colorCodesDark[property] ?? "", in: .main, compatibleWith: nil)), forKeyPath: property)
                    } else {
                        palette.setValue(UIColor(dynamicProvider: { traitCollection -> UIColor in
                            if traitCollection.userInterfaceStyle == .light {
                                return UIColor(hexString: colorCodesLight[property] ?? "")
                            } else {
                                return UIColor(hexString: colorCodesDark[property] ?? "")
                            }
                        }), forKeyPath: property)
                    }
                }
            }
        } else {
            guard let colorCodes = self.readFrom(plist: palette.name) else {
#if canImport(LoggerCenter)
                LogCenter.default.error("Couldn't initialize for color palette type \(palette.name)")
#endif
                return
            }
#if canImport(LoggerCenter)
            LogCenter.default.verbose("Initializing color palette type \(palette.name)")
#endif
            for (property, colorCode) in colorCodes {
                if property.starts(with: "img") {
                    palette.setValue(UIImage(named: colorCode), forKeyPath: property)
                } else {
                    palette.setValue(UIColor(hexString: colorCode), forKeyPath: property)
                }
            }
        }
    }

    public func currentPalette<T: Palette>() -> T? {
        return palette as? T
    }

    func readFrom(plist name: String) -> [String: String]? {
        if let path = Bundle.main.path(forResource: name, ofType: "plist"), let colorCodes = NSDictionary(contentsOfFile: path) as? [String: String] {
            return colorCodes
        }
        return nil
    }
}

@available(iOS 13.0, *)
extension UIImage {
    /// Creates a dynamic image that supports displaying a different image asset when dark mode is active.
    convenience init?(dynamicImageWithLight makeLight: @autoclosure () -> UIImage?,
                      dark makeDark: @autoclosure () -> UIImage?
    ) {
        self.init()
        guard let lightImg = makeLight(), let darkImg = makeDark() else { return nil }
        self.imageAsset?.register(lightImg, with: UITraitCollection(userInterfaceStyle: .light))
        self.imageAsset?.register(darkImg, with: UITraitCollection(userInterfaceStyle: .dark))
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
