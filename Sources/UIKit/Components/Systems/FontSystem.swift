
//
//  FontSystem.swift
//  DesignUIKit
//
//  Provides a customizable font management system for UIKit interfaces, supporting
//  font family switching, observer notification, and font style abstraction.
//
//  Created by Duc IT. Nguyen Minh on 08/01/2024.
//

import UIKit
import DesignCore

/// `Calligraphiable` is a protocol for UI elements or objects that can have their font updated dynamically.
/// Objects conforming to this protocol can be registered with the `FontSystem` as observers to be notified
/// when the font family or style changes, enabling live font switching throughout the app.
public protocol Calligraphiable: AnyObject {
    var font: UIFont { get set }
}

/// `FontSystem` is a singleton class responsible for managing the current font family used throughout the app.
///
/// - Maintains the current `FontFamily` and a font size multiplier.
/// - Allows switching the current font family via `use(_:)`.
/// - Supports observer registration for objects conforming to `Calligraphiable`, and notifies them of font changes.
/// - Provides a method to fetch a font for a given style.
///
/// Usage:
/// ```
/// FontSystem.shared.use(MyCustomFontFamily())
/// FontSystem.shared.register(observer: myLabel)
/// ```
public class FontSystem {
    /// The shared singleton instance.
    public static var shared: FontSystem = .init()
    /// The default font family (system font).
    public static var defaultFont: FontFamily = .System()
    
    /// The currently active font family.
    public var current: FontFamily
    /// The multiplier applied to all font sizes.
    public var multiplier: CGFloat = 1
    
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    /// Initializes the font system with an optional starting font family.
    public init(current: FontFamily? = nil) {
        self.current = current ?? Self.defaultFont
        notifyObservers()
    }
    
    /// Switches the current font family and notifies all registered observers.
    public func use(_ font: FontFamily) {
        current = font
        notifyObservers()
    }
    
    /// Registers a `Calligraphiable` observer to receive font updates.
    public func register<Observer: Calligraphiable>(observer: Observer) {
        if !observers.contains(observer) {
            observers.add(observer)
        }
        notify(observer)
    }
    
    /// Unregisters a `Calligraphiable` observer.
    func unregister<Observer: Calligraphiable>(_ observer: Observer) {
        observers.remove(observer)
    }
    
    /// Notifies all registered observers of the current font change.
    private func notifyObservers() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap({ $0 as? Calligraphiable })
                .forEach(self.notify(_:))
        }
    }
    
    /// Notifies a single observer and updates its font property.
    func notify(_ observer: Calligraphiable) {
        observer.font = current.font(
            with: .init(
                size: observer.font.pointSize,
                weight: observer.font.weight
            )
        )
    }
    
    /// Returns a font instance for the current font family and given style.
    public func font(with style: FontFamily.Style) -> UIFont {
        current.font(with: style, multiplier: multiplier)
    }
}

/// `FontFamily` is an abstract base class representing a font family,
/// capable of producing `UIFont` instances for various styles and weights.
///
/// Subclass this to provide custom font file names and loading logic.
@objc open class FontFamily: NSObject {
    /// The base name of the font family.
    public var name: String
    
    public init(name: String) { self.name = name }
    
    /// Returns a `UIFont` for the given style and multiplier.
    /// Override this method to customize font loading logic.
    open func font(with style: Style, multiplier: CGFloat = 1) -> UIFont {
        var font: UIFont?
        switch style.weight {
        case .ultraLight:
            font = .init(name: name + "-UltraLight", size: style.size * multiplier)
        case .light:
            font = .init(name: name + "-Light", size: style.size * multiplier)
        case .thin:
            font = .init(name: name + "-Thin", size: style.size * multiplier)
        case .medium:
            font = .init(name: name + "-Medium", size: style.size * multiplier)
        case .semibold:
            font = .init(name: name + "-Semibold", size: style.size * multiplier)
        case .bold:
            font = .init(name: name + "-Bold", size: style.size * multiplier)
        case .heavy:
            font = .init(name: name + "-Heavy", size: style.size * multiplier)
        case .black:
            font = .init(name: name + "-Black", size: style.size * multiplier)
        default:
            font = .init(name: name, size: style.size * multiplier)
        }
        guard let font else {
            fatalError("Font with name \(name) of style: \(style.weight.symbolWeight())" )
        }
        return font
    }
}

/// `FontFamily.System` is a subclass of `FontFamily` that represents the system font.
/// It overrides font loading to always return the built-in system font for the given style and weight.
public extension FontFamily {
    class System: FontFamily {
        public static let shared: System = .init()
        
        init() { super.init(name: "system") }
        public override func font(with style: FontFamily.Style, multiplier: CGFloat = 1) -> UIFont {
            .systemFont(ofSize: style.size * multiplier, weight: style.weight)
        }
    }
}

/// `FontFamily.Style` encapsulates font size and weight.
/// Used to describe the desired appearance of a font.
extension FontFamily {
    open class Style: NSObject, Chainable {
        /// The point size of the font.
        public var size: CGFloat
        /// The weight of the font.
        public var weight: UIFont.Weight
        
        public init(size: CGFloat, weight: UIFont.Weight) {
            self.size = size
            self.weight = weight
        }
    }
}

/// Extension to `UIFont` providing a computed property to extract the font weight from the font's descriptor.
/// Returns `.regular` if the weight cannot be determined.
fileprivate extension UIFont {
    var weight: UIFont.Weight {
        guard let weightNumber = traits[.weight] as? Double else { return .regular }
        let weight = UIFont.Weight(rawValue: weightNumber)
        return weight
    }
    
    private var traits: [UIFontDescriptor.TraitKey: Any] {
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        ?? [:]
    }
}
