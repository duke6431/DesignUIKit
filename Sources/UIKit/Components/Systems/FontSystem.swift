//
//  File.swift
//
//
//  Created by Duc IT. Nguyen Minh on 08/01/2024.
//

import UIKit
import DesignCore

public protocol Calligraphiable: AnyObject {
    var font: UIFont { get set }
}

public class FontSystem {
    public static var shared: FontSystem = .init()
    public static var defaultFont: FontFamily = .System()

    public var current: FontFamily
    public var multiplier: CGFloat = 1

    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    public init(current: FontFamily? = nil) {
        self.current = current ?? Self.defaultFont
        notifyObservers()
    }

    public func use(_ font: FontFamily) {
        current = font
        notifyObservers()
    }

    public func register<Observer: Calligraphiable>(observer: Observer) {
        if !observers.contains(observer) {
            observers.add(observer)
        }
        notify(observer)
    }

    func unregister<Observer: Calligraphiable>(_ observer: Observer) {
        observers.remove(observer)
    }

    private func notifyObservers() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap({ $0 as? Calligraphiable })
                .forEach(self.notify(_:))
        }
    }

    func notify(_ observer: Calligraphiable) {
        observer.font = current.font(
            with: .init(
                size: observer.font.pointSize,
                weight: observer.font.weight
            )
        )
    }

    public func font(with style: FontFamily.Style) -> UIFont {
        current.font(with: style, multiplier: multiplier)
    }
}

@objc open class FontFamily: NSObject {
    public var name: String

    public init(name: String) { self.name = name }

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

public extension FontFamily {
    class System: FontFamily {
        public static let shared: System = .init()

        init() { super.init(name: "system") }
        public override func font(with style: FontFamily.Style, multiplier: CGFloat = 1) -> UIFont {
            .systemFont(ofSize: style.size * multiplier, weight: style.weight)
        }
    }
}

extension FontFamily {
    open class Style: NSObject, Chainable {
        public var size: CGFloat
        public var weight: UIFont.Weight

        public init(size: CGFloat, weight: UIFont.Weight) {
            self.size = size
            self.weight = weight
        }
    }
}

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
